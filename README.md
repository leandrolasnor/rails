## Rails API | Docker | Redis | MeiliSearch | ActionCable | Sidekiq

Faça o clone do repositório `git clone git@github.com:leandrolasnor/rails.git`

Entre na pasta do projeto `cd rails`

Rode as migrations e seed: `docker compose run --rm api rails db:reset`

Rode os serviços via Docker :whale: `docker compose up -d`

Agora rode `docker compose ps` e deverá ter cinto containers de pé

`rails` `redis` `sidekiq`
`meilisearch` `cable`

#### [routes](http://localhost:3000/rails/info/routes)

****Para validar as funcionalidade aqui implementadas, utilize este [front-end](https://github.com/leandrolasnor/react) em react****

##### Rode os teste `docker exec -it rails rspec spec`
