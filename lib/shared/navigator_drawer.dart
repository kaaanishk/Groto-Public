import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto/enums/view_state.dart';
import 'package:groto/models/user_model.dart';
import 'package:groto/shared/strings.dart';
import 'package:provider/provider.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        minimum: EdgeInsets.all(8.0),
        child: Consumer<UserModel>(
          builder: (context, userModel, _) {
            return Column(
              children: <Widget>[
                _profile(context, userModel),
                Divider(
                  color: Colors.black,
                ),
                ListTile(
                  title: Text('Your Orders'),
                  onTap: () {
                    Navigator.pushNamed(context, ordersView);
                  },
                ),
                if (ModalRoute.of(context).settings.name == itemsView)
                  ListTile(
                    title: Text('Shops'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
//                ListTile(
//                  title: Text('Payments'),
//                  onTap: () {
//                    Navigator.pushNamed(
//                      context,
//                      '/payments',
//                    );
//                  },
//                ),
//                Divider(
//                  color: Colors.black,
//                ),
//                Center(
//                  child: Text('Previous Orders'),
//                ),
//                Divider(
//                  color: Colors.black,
//                ),
//                ListTile(
//                  title: Text('Help'),
//                  onTap: () {},
//                ),
//                ListTile(
//                  title: Text('Settings'),
//                  onTap: () {},
//                ),
                userModel.state == ViewState.BUSY
                    ? CupertinoActivityIndicator()
                    : ListTile(
                        title: Text('Log Out'),
                        onTap: () async {
                          await userModel.logOut();
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, loginView);
                        },
                      )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _profile(BuildContext context, UserModel userModel) {
    double WIDTH = MediaQuery.of(context).size.width;
    String name = userModel.name;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: WIDTH / 7,
          ),
          Text(
            name,
          )
        ],
      ),
    );
  }
}
