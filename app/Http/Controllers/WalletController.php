<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Wallet;
use Illuminate\Support\Facades\Auth;

class WalletController extends Controller
{
    public function index() {
        $wallets = Wallet::where("user_id", Auth::id())->get();
        return response()->json($wallets);
    }

    public function store(Request $request) {
        try{
            $request->validate([
                "name" => "required"
            ]);

            Wallet::create([
                "user_id" => Auth::id(),
                "name" => $request->name
            ]);

            return response()->json(["success" => "Carteira criada com sucesso!"]);
        }catch(\Exception $e) {
            return response()->json(["error" => $e->getMessage()]);
        }
    }

    public function update(Request $request, $id) {
        try{
            $wallet = Wallet::where("id", $id)->where("user_id", Auth::id())->firstOrFail();

            $request->validate([
                "name" => "required"
            ]);

            $wallet->update([
                "name" => $request->name
            ]);
        }catch(\Exception $e) {
            return response()->json(["error" => $e->getMessage()]);
        }
    }

    public function delete($id) {
        $wallet = Wallet::where("id", $id)->where("user_id", Auth::id())->firstOrFail();
        $wallet->delete();

        return response()->json(["success" => "Carteira apagada com sucesso!"]);
    }
}
