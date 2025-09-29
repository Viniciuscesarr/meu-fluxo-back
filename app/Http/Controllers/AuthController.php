<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\PersonalAccessToken;

class AuthController extends Controller
{
    function register(Request $request) {
       $request->validate([
            "name" => "required|string|max:100",
            "email" => "required|email:rfc,dns|unique:users,email",
            "password" => "required|min:6|confirmed"
        ]);

        $user = User::create([
            "name" => $request->name,
            "email" => $request->email,
            "password" => Hash::make($request->password)
        ]);

        $token = $user->createToken('api-token', ['post:read', 'post:create'])->plainTextToken;

        return response()->json(["ok" => true, "user" => $user, "token" => $token]);
    }

    function login(Request $request) {
        $validated = $request->validate([
            "email" => "required|email:rfc,dns",
            "password" => "required|min:6"
        ]);

        if(Auth::attempt($validated)) {
            $user = User::where("email", $validated["email"])->firstOrFail();

            $token = $user->createToken('api-token', ['post:read', 'post:create'])->plainTextToken;

            return response()->json(["ok" => true, "token" => $token]);
        }
        return response()->json(["error" => false], 401);
    }

    function logout(Request $request){
        $token = $request->bearerToken();
        if(!$token){
                return response()->json(["msg" => "Token não informado!"]);
        }
        $access_token = PersonalAccessToken::findToken($token);
        if(!$access_token){
                return response()->json(["msg" => "Token não informado!"]);
        }

        $access_token->delete();
        return response()->json(["msg" => "token apagado com sucesso"], 200);
    }
}
