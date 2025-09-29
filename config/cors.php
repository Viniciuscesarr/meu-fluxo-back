<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie', 'login', 'logout', 'register'],
    
    'allowed_methods' => ['*'],
    
    'allowed_origins' => [
        'https://seu-frontend.vercel.app',
        'http://localhost:3000',
        'http://localhost:5173' // ou a porta do seu frontend local
    ],
    
    'allowed_origins_patterns' => [],
    
    'allowed_headers' => ['*'],
    
    'exposed_headers' => [],
    
    'max_age' => 0,
    
    'supports_credentials' => true,
];