Learning clean-architecture.

using
    puma: http server
        https://github.com/puma/puma
    rack: middleware interface
        https://github.com/rack/rack
    roda: routing
        https://github.com/jeremyevans/roda


## API Routes

### Authentication

- POST api/register
- POST api/login
- POST api/logout

### User

- GET api/user -> indentify with token
- GET api/users
- PUT api/users/{id}
- DELETE api/users/{id}

### Treads

- GET api/threads/{id}
- GET api/threads
- POST api/threads
- PATCH api/threads/{id}
- DELETE api/threads/{id}

### Comments

- GET api/threads/{thread_id}/comments
- GET api/comments/{id}
- POST api/comments
- PATCH api/comments/{id}
- DELETE api/comments/{id}


## DatabaseSchema

### Users

- `id`: int (primary key)
- `name`: varchar(255)
- `email`: varchar(255)
- `password`: varchar(255)
- `created_at`: timestamp
- `updated_at`: timestamp

### Threads

- `id`: int (primary key)
- `user_id`: int (foreign key to Users table)
- `title`: varchar(255)
- `body`: text
- `created_at`: timestamp
- `updated_at`: timestamp

### Comments

- `id`: int (primary key)
- `user_id`: int (foreign key to Users table)
- `thread_id`: int (foreign key to Threads table)
- `body`: text
- `upvotes`: int
- `created_at`: timestamp
- `updated_at`: timestamp
