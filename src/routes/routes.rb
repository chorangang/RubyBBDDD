ROUTES = [
    # route template
    # { method: , path: '', controller: '', action: : },

    # Auth
    { method: 'POST', path: '/api/register', controller: 'AuthController', action: :register },
    { method: 'POST', path: '/api/login',    controller: 'AuthController', action: :login },
    { method: 'POST', path: '/api/logout',   controller: 'AuthController', action: :logout },
    { method: 'GET',  path: '/api/user',     controller: 'AuthController', action: :user },

    # Users
    { method: 'GET',    path: '/api/users',     controller: 'UsersController', action: :index },
    { method: 'GET',    path: '/api/users/:id', controller: 'UsersController', action: :show },
    { method: 'PUT',    path: '/api/users/:id', controller: 'UsersController', action: :update },
    { method: 'DELETE', path: '/api/users/:id', controller: 'UsersController', action: :destroy },

    # Threads
    { method: 'GET',    path: '/api/threads',     controller: 'ThreadsController', action: :index },
    { method: 'POST',   path: '/api/threads',     controller: 'ThreadsController', action: :save },
    { method: 'GET',    path: '/api/threads/:id', controller: 'ThreadsController', action: :show },
    { method: 'PUT',    path: '/api/threads/:id', controller: 'ThreadsController', action: :update },
    { method: 'DELETE', path: '/api/threads/:id', controller: 'ThreadsController', action: :destroy },

    # Comments
    { method: 'GET',    path: '/api/threads/:thread_id/comments', controller: 'CommentsController', action: :index },
    { method: 'POST',   path: '/api/comments',             controller: 'CommentsController', action: :save },
    { method: 'PUT',    path: '/api/comments/:id',         controller: 'CommentsController', action: :update },
    { method: 'DELETE', path: '/api/comments/:id',         controller: 'CommentsController', action: :destroy },
]
