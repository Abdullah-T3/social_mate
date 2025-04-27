abstract class AuthenticationRemoteDataSource {
  //login setup by marwan
  Future<String> login(String email, String password);
  Future signUp(String firstName, String lastName,String email, String phone, String password,String selectedGender);

}