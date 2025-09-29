    <?php

    use Illuminate\Http\Request;
    use Illuminate\Support\Facades\Route;
    use App\Http\Controllers\AuthController;
    use App\Http\Controllers\CategoryController;
    use App\Http\Controllers\TransactionController;
    use App\Http\Controllers\WalletController;

    Route::get('/user', function (Request $request) {
        return $request->user();
    })->middleware('auth:sanctum');

    Route::post("/register", [AuthController::class, 'register']);
    Route::post("/login", [AuthController::class, 'login']);
    Route::post("/logout", [AuthController::class, 'logout']);

    Route::middleware(['auth:sanctum'])->group(function () {
        Route::get("/transactions", [TransactionController::class, 'index']);
        Route::post("/transaction", [TransactionController::class, 'store']);
        Route::put("/transaction/{id}", [TransactionController::class, 'update']);
        Route::delete("/transaction/{id}", [TransactionController::class, 'destroy']);

        Route::get("/categories", [CategoryController::class, "index"]);
        Route::post("/categories", [CategoryController::class, "store"]);
        Route::put("/category/{id}", [CategoryController::class, "update"]);
        Route::delete("/category/{id}", [CategoryController::class, "destroy"]);

        Route::get("/wallets", [WalletController::class, 'index']);
        Route::post("/wallets", [WalletController::class, 'store']);
        Route::put("/wallet/{id}", [WalletController::class, 'update']);
        Route::delete("/wallet/{id}", [WalletController::class, 'destroy']);
    });

    Route::middleware('auth:sanctum')->get('/saldo-geral', [TransactionController::class, 'saldoGeral']);   