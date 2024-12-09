import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _obscurePassword = true;
  String? _savedUsername;
  String? _savedEmail;

  @override
  void initState() {
    super.initState();
    _loadSavedAccount();
  }

  // Fungsi untuk memuat data akun dari SharedPreferences
  Future<void> _loadSavedAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedUsername = prefs.getString('savedUsername');
      _savedEmail = prefs.getString('savedEmail');
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedUsername = prefs.getString('savedUsername');
    final String? savedPassword = prefs.getString('savedPassword');
    final String? savedEmail = prefs.getString('savedEmail');

    if (_usernameController.text == savedUsername &&
        _passwordController.text == savedPassword &&
        _emailController.text == savedEmail) {
      await prefs.setBool('isLoggedIn', true);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Gagal'),
          content: const Text('Username, password, atau email salah!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'KAY',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NothingYouCould',
                        color: Color.fromARGB(255, 62, 19, 216),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('Log in'),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateAccountPage()),
                        );
                      },
                      child: const Text("Create account"),
                    ),
                    const Text(" or "),
                    TextButton(
                      onPressed: () {
                        // Reset password logic
                      },
                      child: const Text("Reset password"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_savedUsername != null && _savedEmail != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Saved Username: $_savedUsername'),
                      Text('Saved Email: $_savedEmail'),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;
  Map<String, String>? _accountDetails;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // Fungsi untuk memuat data yang disimpan
  Future<void> _loadSavedData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('savedUsername');
    final String? email = prefs.getString('savedEmail');
    final String? password = prefs.getString('savedPassword');

    if (username != null && email != null && password != null) {
      setState(() {
        _accountDetails = {
          'Username': username,
          'Email': email,
          'Password': password,
        };
      });
    }
  }

  // Fungsi untuk menyimpan data
  Future<void> _saveData(String username, String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedUsername', username);
    await prefs.setString('savedEmail', email);
    await prefs.setString('savedPassword', password);
  }

  // Fungsi untuk menghapus data
  Future<void> _deleteAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedUsername');
    await prefs.remove('savedEmail');
    await prefs.remove('savedPassword');

    setState(() {
      _accountDetails = null; // Reset state
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account Deleted Successfully!')),
    );
  }

  // Fungsi untuk membuat akun
  void _createAccount() {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required!')),
      );
      return;
    }

    // Simpan data ke SharedPreferences
    _saveData(username, email, password);

    // Perbarui state untuk menampilkan data
    setState(() {
      _accountDetails = {
        'Username': username,
        'Email': email,
        'Password': password,
      };
    });

    // Reset input fields
    _usernameController.clear();
    _emailController.clear();
    _passwordController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account Created Successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Input Username
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Input Email
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Input Password dengan Icon Eyes
              TextField(
                controller: _passwordController,
                obscureText: _isObscured,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Submit
              ElevatedButton(
                onPressed: _createAccount,
                child: const Text('Create Account'),
              ),

              const SizedBox(height: 24),

              // Menampilkan hasil data yang diisi
              if (_accountDetails != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Details:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Username: ${_accountDetails!['Username']}'),
                    Text('Email: ${_accountDetails!['Email']}'),
                    Text('Password: ${_accountDetails!['Password']}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _deleteAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Tombol warna merah
                      ),
                      child: const Text('Delete Account'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
