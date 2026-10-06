# Comparativo Gasolina x Álcool

Aplicativo em Flutter que compara o preço do litro do álcool com o da gasolina e indica qual combustível compensa mais.

**Instituição:** Instituto Federal do Piauí (IFPI), Campus Teresina Central
**Curso:** Análise e Desenvolvimento de Sistemas
**Disciplina:** Programação para Dispositivos Móveis
**Professor:** Otílio Paulo
**Aluno:** Guilherme Alves Barbosa

## Sobre o projeto

O usuário informa o preço do litro de cada combustível e toca em **Calcular**. O resultado só aparece depois do clique, com mensagem e cor de acordo com a situação.

## Como funciona o cálculo

```
resultado = (valor do álcool / valor da gasolina) * 100
```

- Se o resultado for **até 70%**, compensa abastecer com **álcool**.
- Se for **maior que 70%**, compensa abastecer com **gasolina**.

> **Observação:** o enunciado da atividade indicava álcool quando o resultado fosse maior ou igual a 70. Como o álcool rende menos que a gasolina, ele só compensa quando custa até 70% do preço dela, então a condição foi invertida.

**Exemplo:** gasolina R$ 100 e álcool R$ 69 → 69% → álcool. Gasolina R$ 100 e álcool R$ 81 → 81% → gasolina.

## Funcionalidades

- Resultado exibido somente após clicar em Calcular
- Mensagem inicial antes do primeiro cálculo
- Aceita vírgula ou ponto nos valores (`4,59` ou `4.59`)
- Validação de campos vazios, textos inválidos, zero e números negativos
- Resultado colorido:
  - Cinza: estado inicial
  - Verde: álcool compensa
  - Laranja: gasolina compensa
  - Vermelho: valores inválidos

## Tecnologias

- [Flutter](https://flutter.dev) [3.47.4]
- Dart [3.13.3]

## Como executar

1. Clone o repositório:
```bash
   git clone https://github.com/Guilherme-sta/programacao-para-dispositivos-moveis.git
```
2. Entre na pasta do projeto:
```bash
   cd programacao-para-dispositivos-moveis/aplicacao_flutter_3
```
3. Instale as dependências:
```bash
   flutter pub get
```
4. Execute o app:
```bash
   flutter run
```

## Estrutura do código

- `main.dart`: contém o `MaterialApp`, a tela principal (`MyHomePage`) e a lógica de cálculo.
- `TextEditingController`: lê os valores digitados.
- `resultado` e `corResultado`: variáveis de estado atualizadas com `setState`.

## Possíveis melhorias

- Botão para limpar os campos
- Exibir o percentual calculado no resultado
- Histórico de consultas