<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ApiController; // <= AQUI

Route::post('/login', [ApiController::class, 'login'])->name('api.login');

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/me', [ApiController::class, 'me'])->name('api.me');
    Route::post('/logout', [ApiController::class, 'logout'])->name('api.logout');

    Route::get('/user', function (Request $request) {
        return $request->user();
    });
});


Route::get('/home', [ApiController::class, 'home'])->name('api.home');