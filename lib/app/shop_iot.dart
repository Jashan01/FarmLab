
import 'package:farm_lab/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farm_lab/custom_widgets/show_alert_diag.dart';


class Shoplist extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  State<Shoplist> createState() => _ShoplistState();
}

class _ShoplistState extends State<Shoplist> {


  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 844);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 390);
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignout = await showAlertDiag(context,
        title: 'Logout',
        content: 'Are you sure you want to logout',
        DefaultActionText: 'Logout',
        cancelActionText: 'Cancel');
    if (didRequestSignout == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'FarmLab',
            style: TextStyle(
              color: Color(0xFF151515),
              fontSize: pW(18),
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFFFFFFF),
          elevation: 0.0,
          leading: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(16), pH(8),0,pH(8)),
            child: Container(
              child: Icon(Icons.add_rounded, size: 20,),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF151515)),
            ),
          ),
          actions: [
            Icon(
              Icons.notifications_none,
              size: pW(24),
              color: Color(0xFF151515),
            ),
            FlatButton(
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Color(0xFF151515),
                ),
              ),
              onPressed: () => _confirmSignOut(context),
              //_confirmSignOut(context),
            )
          ],
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildContents(context)
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildContents(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(pW(16), pW(20), pW(17), pW(50)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Shop IoT',
            style: TextStyle(
                color: Color(0xFF151515),
                fontSize: pW(24),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: pW(10),
          ),

      Container(
        height: pW(50),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(pW(8)),

        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(pW(10), 0, pW(16), 0),
          child: TextField(

              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded,
                    color: Color(0xFF151515),
                    size: pW(32),
                  ),
                  labelText: 'Search IoT Devices',
                  labelStyle: TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: pW(18)
                  ),
                  border: InputBorder.none,
              )
          ),
        ),
      ),

          SizedBox(
            height: pW(18),
          ),
          Text(
            'Recommended Products',
            style: TextStyle(
              color: Color(0xFF151515),
              fontSize: pW(20),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: pW(8),
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (BuildContext context,int index){
                return Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pW(12)),
                  child: Container(

                    decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(pW(12))
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(pW(12), pW(12), pW(14), pW(13)),
                      child: Row(
                        children: [
                          Container(
                            width: pW(112),
                            height: pW(116),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(pW(10)),
                              image: DecorationImage(

                                fit: BoxFit.fill,
                                image: NetworkImage("https://mcfp.jo/Content/articles/2020/11/25/How%20important%20is%20heat%20for%20organic%20fertilizers_1500x1500.jpg"),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: pW(12),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Organic Compost',
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,

                                      style: TextStyle(
                                        color: Color(0xFF151515),
                                        fontSize: pW(16),
                                        fontWeight: FontWeight.w700,

                                      ),
                                    ),

                                    SizedBox(
                                      height: pW(4),
                                    ),

                                    Text(
                                      'Best compost for the healthy growth of plants',
                                      maxLines: 2,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,


                                      style: TextStyle(
                                        color: Color(0xFFBDBDBD),
                                        fontSize: pW(12),
                                        fontWeight: FontWeight.w500,

                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: pW(16),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₹ 2450',
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,

                                      style: TextStyle(
                                        color: Color(0xFF151515),
                                        fontSize: pW(18),
                                        fontWeight: FontWeight.w700,

                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Color(0xFF151515),
                                              size: pW(16),
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Color(0xFF151515),
                                              size: pW(16),
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Color(0xFF151515),
                                              size: pW(16),
                                            ),
                                            Icon(
                                              Icons.star_border,
                                              color: Color(0xFF151515),
                                              size: pW(16),
                                            ),
                                            Icon(
                                              Icons.star_border,
                                              color: Color(0xFF151515),
                                              size: pW(16),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.shopping_cart_outlined,
                                          color: Color(0xFF151515),
                                          size: pW(20),
                                        ),
                                      ],
                                    )
                                  ],
                                )


                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
          ),
        ],
      ),
    );
  }




}
