import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kbc/services/firedb.dart';
import 'package:kbc/services/localdb.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<User?> signWithGoogle() async {
  try {
    final GoogleSignInAccount? googlesignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googlesignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final usercredential = await _auth.signInWithCredential(credential);
    final User? user = usercredential.user;

    assert(!user!.isAnonymous);
    assert(await user!.getIdToken() != null);

    final User? currentUser = await _auth.currentUser;
    assert(currentUser!.uid == user!.uid);
    await LocalDB.saveuserID(user!.uid);
    await LocalDB.saveName(user.displayName.toString());
    await LocalDB.saveUrl(user.photoURL.toString());

    print(user);
    await FireDB().createNewUser(user.displayName.toString(),
        user.email.toString(), user.photoURL.toString(), user.uid);
  } catch (e) {
    print("Error thid");
    print(e);
  }
}

Future<String?> signOut() async {
  await googleSignIn.signOut();
  await _auth.signOut();
  await LocalDB.saveuserID("null");
  await LocalDB.saveLevel("null");
  await LocalDB.saveMoney("null");
  await LocalDB.saveName("null");
  await LocalDB.saveRank("null");
  await LocalDB.saveUrl("null");

  return "SUCCESS";
}
