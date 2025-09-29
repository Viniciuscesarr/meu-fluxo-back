<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Transaction;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class TransactionController extends Controller
{
    public function index() {
        $transactions = Transaction::where("user_id", Auth::id())->with("wallet")->with("categorie")->get();
        return response()->json(["dados" => $transactions], 200);
    }

    public function store(Request $request) {
        try{
            $request->validate([
            "wallet_id" => "required|integer|exists:wallets,id",
            "categorie_id" => "required|integer|exists:categories,id",
            "amount" => "required|numeric",
            "type" => "required|in:income,expense"
        ]);

        Transaction::create([
            "user_id" => Auth::id(),
            "wallet_id" => $request->wallet_id,
            "type" => $request->type,
            "categorie_id" => $request->categorie_id,
            "amount" => $request->amount
        ]);

        return response()->json(["success" => "Transação criada com sucesso!"], 201);

    }catch(\Exception $e) {
            return response()->json(["error" => $e->getMessage()], 500);
        }
    }

    public function update($id, request $request) {
        try{
            $transaction = Transaction::where("id", $id)->where("user_id", Auth::id())->firstOrFail();
        $request->validate([
            "wallet_id" => "required|integer|exists:wallets,id",
            "categorie_id" => "required|integer|exists:categories,id",
            "amount" => "required|numeric"
        ]);


        $transaction->update([
            "wallet_id" => $request->wallet_id,
            "categorie_id" => $request->categorie_id,
            "amount" => $request->amount
        ]);

        return response()->json(["success" => "Transação atualizada com sucesso!"]);
        }catch(\Exception $e) {
            return response()->json(["error" => $e->getMessage()], 500);
        }
    }

    public function destroy($id) {
        $transaction = Transaction::where("id", $id)->where("user_id", Auth::id())->firstOrFail();
        $transaction->delete();

        return response()->json(["success" => "Transação deletada com sucesso!"]);
    }

    public function saldoGeral()
    {
        $userId = Auth::id(); 

        $saldo = DB::table('transactions as t')
            ->join('wallets as w', 't.wallet_id', '=', 'w.id')
            ->where('w.user_id', $userId)
            ->select(DB::raw("
                SUM(
                    CASE WHEN t.type = 'income' THEN t.amount
                         WHEN t.type = 'expense' THEN -t.amount
                    END
                ) as saldo_geral
            "))
            ->first();

        return response()->json([
            'saldo_geral' => $saldo->saldo_geral ?? 0
        ]);
    }
}
