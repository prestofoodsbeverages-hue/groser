<?php

use Illuminate\Support\Facades\Route;

Route::get('/', fn () => response()->json([
    'service' => 'Groser Railway Reverb',
    'status' => 'ok',
]));
