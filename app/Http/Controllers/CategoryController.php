<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Categorie;
use Illuminate\Support\Facades\Auth;

class CategoryController extends Controller
{
    public function index(){
        $categories = Categorie::where("user_id", Auth::id())->get();
        return response()->json(["dados" => $categories], 200);
    }

    public function store(Request $request) {
        try{

            $request->validate([
                "name" => "required"
            ], [
                "name.required" => "Nome não informado!"
            ]);
            Categorie::create([
                "user_id" => Auth::id(),
                "name" => $request->name,
            ]);

            return response()->json(["success" => "Categoria criada com sucesso!"], 201);
        }catch(\Exception $e) {
            return response()->json(["error" => $e->getMessage()], 500);
        }
    }

    public function update($id) {
       try{
         $category = Categorie::where("id", $id)->where("user_id", Auth::id())->firstOrFail();
        
         $category->update([
            "name" => "required"
         ], [
            "name.required" => "Nome não informado!"
         ]);

         return response()->json(["success" => "Categoria atualizada com sucesso!"], 200);
       }catch(\Exception $e) {
         return response()->json(["error" => $e->getMessage()], 500);
       }
    }

    public function destroy($id){
        $category = Categorie::where("id", $id)->where("user_id", Auth::id())->firstOrFail();
        $category->delete();
        return response()->json(["success" => "Categoria apagada com sucesso!"]);
    }
}
