<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;

class AssociadoController extends Controller
{
    public function __construct()
    {
        $this->middleware(['auth', 'role:associado']);
    }

    public function index()
    {
        // View única com header (nome/e-mail), logout e formulário de senha
        return view('associado.dashboardassociado');
    }

    /**
     * Primeira definição de senha (sem exigir senha atual).
     * Só deve ser usado enquanto must_set_password=true OU password estiver null.
     */
    public function definirSenha(Request $request)
    {
        $user = $request->user();

        // Se ele já definiu senha, não deixa usar este endpoint de novo
        if (!$user->must_set_password && !is_null($user->password)) {
            return back()->withErrors('Sua senha já foi definida. Use "Alterar senha".');
        }

        $data = $request->validate([
            'password' => ['required', 'confirmed', Password::min(8)->letters()->numbers()],
        ]);

        $user->password = Hash::make($data['password']);
        $user->must_set_password = false;
        $user->email_verified_at = $user->email_verified_at ?: now();
        $user->save();

        return back()->with('ok', 'Senha definida com sucesso. Da próxima vez, faça login com sua senha.');
    }

    /**
     * Alteração normal de senha (exige senha atual).
     */
    public function alterarSenha(Request $request)
    {
        $user = $request->user();

        $data = $request->validate([
            'current_password' => ['required'],
            'password'         => ['required', 'confirmed', Password::min(8)->letters()->numbers()],
        ]);

        if (!Hash::check($data['current_password'], $user->password)) {
            return back()->withErrors(['current_password' => 'Senha atual inválida.']);
        }

        // Evita trocar por uma senha idêntica
        if (Hash::check($data['password'], $user->password)) {
            return back()->withErrors(['password' => 'A nova senha não pode ser igual à senha atual.']);
        }

        $user->password = Hash::make($data['password']);
        $user->save();

        return back()->with('ok', 'Senha alterada com sucesso.');
    }
}
