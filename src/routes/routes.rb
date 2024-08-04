ROUTES = [
    # template
    # { method: , path: '', controller: '', action: : },

    # Auth
    { method: 'POST', path: '/api/register', controller: 'AuthController', action: :register },
    { method: 'POST', path: '/api/login', controller: 'AuthController', action: :login },
    { method: 'POST', path: '/api/logout', controller: 'AuthController', action: :logout },
    { method: 'GET', path: '/api/user', controller: 'AuthController', action: :user },
]