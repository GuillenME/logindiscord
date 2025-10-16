Import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
    const LoginScreen({Key? key}) : super(key: key);

    @override
    State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    final _formKey = GlobalKey<FormState>();
    String _email = '';
    String _password = '';

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            const Text(
                                'Bienvenido',
                                style: TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Correo',
                                    border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                    if (value == null || value.isEmpty) {
                                        return 'Por favor ingresa tu correo';
                                    }
                                    return null;
                                },
                                onSaved: (value) => _email = value!,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                    labelText: 'Contraseña',
                                    border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                    if (value == null || value.length < 6) {
                                        return 'La contraseña debe tener al menos 6 caracteres';
                                    }
                                    return null;
                                },
                                onSaved: (value) => _password = value!,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Iniciando sesión...')),
                                    );
                                }
                                },
                                child: const Text('Aceptar'),
                            ),
                            const SizedBox(height: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    const Text('¿No tienes una cuenta?'),
                                    TextButton(
                                    onPressed: () {
                                        Navigator.pushNamed(context, '/register');
                                    },
                                    child: const Text('Crea una'),
                                    ),
                                ],
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Iniciando sesión con Discord...')),
                                    );
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[700],
                                ),
                                child: const Text('Iniciar sesión con Discord'),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}
