<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    protected $fillable = ["wallet_id", "categorie_id", "user_id", "amount", "type"];

    public function wallet() {
        return $this->belongsTo(Wallet::class);
    }

    public function categorie() {
        return $this->belongsTo(Categorie::class);
    }
}
