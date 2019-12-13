// RTAL
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto/enums/connectivity_state.dart';
import 'package:groto/models/location_model.dart';
import 'package:groto/models/order_model.dart';
import 'package:groto/models/user_model.dart';
import 'package:groto/services/authentication_service.dart';
import 'package:groto/services/connectivity_service.dart';
import 'package:groto/shared/strings.dart';
import 'package:groto/shared/user.dart';
import 'package:groto/views/auth/login_email_view.dart';
import 'package:groto/views/auth/login_view.dart';
import 'package:groto/views/auth/reset_password_view.dart';
import 'package:groto/views/auth/signup_view.dart';
import 'package:groto/views/bill_view.dart';
import 'package:groto/views/coming_soon_view.dart';
import 'package:groto/views/item_view.dart';
import 'package:groto/views/orders_view.dart';
import 'package:groto/views/pickup_bill_view.dart';
import 'package:groto/views/retailer_view.dart';
import 'package:provider/provider.dart';

// TODO: Add a proper way to log the important stuff.
// TODO: Shift to named parameters in function calls
// TODO: Currently shifting to proper state management -> (Mostly Done)
// TODO: Figure out ways to reuse widgets -> Working on this. Adding a proper architecture.
// TODO: Animations -> Can be done later
// TODO: Error checking -> Working on this.
// TODO: Payment support -> Scraped for now
// TODO: Once UI is fixed. Try and reduce redundant code. -> Working on this
// TODO: Documentation -> Can be done later
// TODO: Add Timeouts -> Priority
// TODO: Permission are partially working -> Priority
// TODO: Notification -> Priority
// TODO: Add a settings page -> Priority?
void main() async {
  User user = await AuthService().isLoggedIn();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => OrderModel()),
        ChangeNotifierProvider(
            builder: (context) =>
                (user == null) ? UserModel() : UserModel(user: user)),
        ChangeNotifierProvider(builder: (context) => LocationModel()),
        StreamProvider<ConnectivityState>(
            builder: (context) =>
                ConnectivityService().connectivityStreamController.stream),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Groto',
        home: (user == null) ? LoginView() : RetailerView(),
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.black,
          scaffoldBackgroundColor: Colors.white,
        ),
        routes: {
          loginView: (context) => LoginView(),
          loginEmailView: (context) => LoginEmailView(),
          signupView: (context) => SignUpView(),
          shopsView: (context) => RetailerView(),
          itemsView: (context) => ItemView(),
          comingSoonView: (context) => ComingSoonView(),
          billView: (context) => BillView(),
          pickupBillView: (context) => PickupBillView(),
          resetPasswordView: (context) => ResetPasswordView(),
          ordersView: (context) => OrdersView(),
        },
      ),
    ),
  );
}
