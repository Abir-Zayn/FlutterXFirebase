import '../auth/auth.dart';
import '../pages/home_page.dart';
import '../pages/loginPage.dart';
import '../pages/profilePage.dart';
import '../pages/registrationPage.dart';


class AppRoutes{

  static final pages ={
    home : (context) =>  const HomePage(),
    login : (context) =>  const loginPage(),
    register: (context) =>  const RegistrationPage(),
    authPage: (context) =>  const AuthPage(),
    profilePage : (context) =>  ProfilePage()

  };

  static const login = '/login';
  static const home = '/home';
  static const register = '/register';
  static const authPage = '/authPage';
  static const profilePage = '/profilePage';

}