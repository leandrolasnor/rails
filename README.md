## Ruby on Rails
### Proof of Concept

Após clonar o repositório

`cd rails`

Rode os serviços via Docker

`docker compose up -d`

Ao final deverá ter cinto containers rodando

`rails`
`meilisearch`
`sidekiq`
`redis`
`cable`

[rotas da api](http://localhost/3000/rails/info/routes)

****Para validar as funcionalidade aqui implementadas, utilize este [front-end](https://github.com/leandrolasnor/react) em react****

#### Para todas os testes de fora do container
`docker exec -it rails rspec spec`
