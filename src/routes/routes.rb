ROUTES = [
    # route template
    # { method: , path: '', controller: '', action: : },

    # Auth
    { method: 'POST', path: '/api/register', controller: 'AuthController', action: :register },
    { method: 'POST', path: '/api/login',    controller: 'AuthController', action: :login },
    { method: 'POST', path: '/api/logout',   controller: 'AuthController', action: :logout },
    { method: 'GET',  path: '/api/user',     controller: 'AuthController', action: :user },
]

# skip_jwt_auth_paths
# JWT認証を素通りできるパスを設定
SKIP_PATHS = [
    '/api/register',
    '/api/login',
]