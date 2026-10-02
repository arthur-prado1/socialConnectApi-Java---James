# Testes da API SocialConnect

## POST http://localhost:8080/api/v1/beneficiarios
**Request Payload:**
``json
{
    "telefone":  "(11) 99999-9999",
    "cpf":  "123.456.789-00",
    "nome":  "JoÃ£o da Silva",
    "situacaoVulnerabilidade":  "Desempregado",
    "endereco":  "Rua das Flores, 123"
}
``
**Response Status:** 201
**Response Payload:**
``json
{
    "idBeneficiario":  2,
    "nome":  "JoÃ£o da Silva",
    "cpf":  "123.456.789-00",
    "telefone":  "(11) 99999-9999",
    "endereco":  "Rua das Flores, 123",
    "situacaoVulnerabilidade":  "Desempregado",
    "dataCadastro":  "2026-10-02"
}
``

## GET http://localhost:8080/api/v1/beneficiarios
**Response Status:** 200
**Response Payload:**
``json
{
    "content":  [
                    {
                        "idBeneficiario":  2,
                        "nome":  "JoÃ£o da Silva",
                        "cpf":  "123.456.789-00",
                        "telefone":  "(11) 99999-9999",
                        "endereco":  "Rua das Flores, 123",
                        "situacaoVulnerabilidade":  "Desempregado",
                        "dataCadastro":  "2026-10-02"
                    },
                    {
                        "idBeneficiario":  1,
                        "nome":  "João da Silva",
                        "cpf":  "12345678900",
                        "telefone":  "11999999999",
                        "endereco":  "Rua das Flores, 123",
                        "situacaoVulnerabilidade":  "Desempregado",
                        "dataCadastro":  "2026-10-02"
                    }
                ],
    "page":  {
                 "size":  10,
                 "number":  0,
                 "totalElements":  2,
                 "totalPages":  1
             }
}
``

## GET http://localhost:8080/api/v1/beneficiarios/1
**Response Status:** 200
**Response Payload:**
``json
{
    "idBeneficiario":  1,
    "nome":  "João da Silva",
    "cpf":  "12345678900",
    "telefone":  "11999999999",
    "endereco":  "Rua das Flores, 123",
    "situacaoVulnerabilidade":  "Desempregado",
    "dataCadastro":  "2026-10-02"
}
``

## GET http://localhost:8080/api/v1/doacoes?tipo=ALIMENTO&dataInicio=2026-01-01
**Response Status:** 200
**Response Payload:**
``json
{
    "content":  [

                ],
    "page":  {
                 "size":  10,
                 "number":  0,
                 "totalElements":  0,
                 "totalPages":  0
             }
}
``

## DELETE http://localhost:8080/api/v1/beneficiarios/1
**Response Status:** 204

