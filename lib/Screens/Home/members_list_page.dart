import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gymapp/Screens/Home/widgets/member_card_widget.dart';
import 'package:gymapp/Theme/appcolor.dart';
import 'package:gymapp/Utils/custom_snack_bar.dart';
import 'package:gymapp/Utils/drawer.dart';
import 'package:gymapp/Screens/Home/AddMember/add_members.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';
import 'member_details_page.dart';

class Membersinfo extends StatefulWidget {
  const Membersinfo({super.key});

  @override
  _MembersinfoState createState() => _MembersinfoState();
}

class _MembersinfoState extends State<Membersinfo> {
  final SupabaseClient supabase = Supabase.instance.client;
  late final user = supabase.auth.currentUser;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredMembers = [];
  List<Map<String, dynamic>> members = [];
  bool isLoading = true;
  String? errorMessage;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    fetchMembers();
    searchController.addListener(_filterMembers);
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (!mounted) return;

    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> fetchMembers() async {
    await checkInternetConnection();

    if (!isConnected) {
      if (!mounted) return;

      setState(() {
        errorMessage = "No Internet Connection!";
        isLoading = false;
      });
      return;
    }

    try {
      final response = await supabase
          .from('memberinfo')
          .select()
          .eq('gymId', user!.id);
      if (!mounted) return;

      setState(() {
        members = List<Map<String, dynamic>>.from(response);
        filteredMembers = members; // Initially, show all members
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = "Failed to load members";
        isLoading = false;
      });
      CustomSnackBar.showSnackBar(
        "Check Internet Connection",
        SnackBarType.failure,
      );
    }
  }

  void _filterMembers() {
    String query = searchController.text.toLowerCase();

    if (!mounted) return;

    setState(() {
      filteredMembers =
          members.where((member) {
            String name = member['name'].toString().toLowerCase();
            return name.contains(query);
          }).toList();
      // members = filteredMembers;
      logger.i(filteredMembers);
    });
  }

  Future<void> deleteMember(String memberId) async {
    try {
      await supabase.from('memberinfo').delete().eq('member_id', memberId);
      if (!mounted) return;

      setState(() {
        members.removeWhere(
          (member) => member['member_id'].toString() == memberId,
        );
      });
      if (mounted) {
        CustomSnackBar.showSnackBar(
          "Member deleted successfully",
          SnackBarType.failure,
        );
      }
    } catch (error) {
      if (mounted) {
        logger.e(error.toString());
        CustomSnackBar.showSnackBar(
          "Failed to delete member",
          SnackBarType.failure,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: GymDrawer(),
      appBar: AppBar(title: Text('Members Information')),
      body:
          isConnected
              ? RefreshIndicator(
                color: AppColors.greenAccent,
                onRefresh: fetchMembers,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 5,
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) => _filterMembers(),
                          decoration: InputDecoration(
                            hintText: "Search members...",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Member List
                      isLoading
                          ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.greenAccent,
                            ),
                          )
                          : filteredMembers.isEmpty
                          ? Text("No members found")
                          : Expanded(
                            child:
                                isLoading
                                    ? Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.greenAccent,
                                      ),
                                    )
                                    : errorMessage != null
                                    ? Center(
                                      child: Text(
                                        errorMessage!,
                                        style: TextStyle(
                                          color: AppColors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                    : GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                screenWidth < 600 ? 2 : 3,
                                            crossAxisSpacing: 15,
                                            mainAxisSpacing: 15,
                                            childAspectRatio: 0.8,
                                          ),
                                      itemCount: filteredMembers.length,
                                      itemBuilder: (context, index) {
                                        final member = filteredMembers[index];

                                        return GestureDetector(
                                          onTap:
                                              () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => MemberDetailsPage(
                                                        member: member,
                                                        onDelete:
                                                            () => deleteMember(
                                                              member['member_id']
                                                                  .toString(),
                                                            ),
                                                      ),
                                                ),
                                              ),
                                          child: MemberCard(
                                            phone: member['mobile'] ?? 'N/A',
                                            name: member['name'] ?? 'N/A',
                                            memberId:
                                                member['member_id'].toString(),
                                            planExpiry: "06-12-2022",
                                            dueAmount:
                                                member['due_amount'].toString(),
                                            profilePic:
                                                (member['member_img'] != null &&
                                                        member['member_img']
                                                            .trim()
                                                            .isNotEmpty)
                                                    ? member['member_img']
                                                    : "https://picsum.photos/500/500?random=$index",
                                            onDelete:
                                                () => deleteMember(
                                                  member['member_id']
                                                      .toString(),
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                          ),
                    ],
                  ),
                ),
              )
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 80, color: Colors.red),
                    SizedBox(height: 10),
                    Text(
                      "No Internet Connection",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: fetchMembers,
                      child: Text("Retry"),
                    ),
                  ],
                ),
              ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        elevation: 8,
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddMemberScreen(gymId: user?.id),
              ),
            ),
        child: Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}
