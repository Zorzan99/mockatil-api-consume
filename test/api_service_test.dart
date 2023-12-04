// Importa as bibliotecas necessárias
import 'package:mockatil_api_consume/api_service.dart';
import 'package:mockatil_api_consume/product.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:uno/uno.dart'; // Importa a classe Uno do pacote uno

// Classe UnoMock que implementa a interface Uno
class UnoMock extends Mock implements Uno {}

class ResponseMock extends Mock implements Response {}

// Função principal de testes
void main() {
  final uno = UnoMock();
  tearDown(() => reset(uno));
  // Teste: Deve retornar uma lista de produtos
  test('Deve retornar uma lista de product', () {
    // Cria uma instância de UnoMock
    final response = ResponseMock();
    when(() => response.data).thenReturn(productListJson);
    when(() => uno.get(any())).thenAnswer((_) async => response);
    final service =
        ApiService(uno); // Cria uma instância de ApiService com UnoMock

    // Verifica se a chamada de getProducts retorna a lista esperada de produtos
    expect(
      service.getProducts(),
      completion(
        [
          Product(id: 1, title: 'title', price: 12.0),
          Product(id: 2, title: 'title2', price: 13.0),
        ],
      ),
    );
  });

  // Teste: Deve retornar uma lista vazia em caso de erro
  test(
      "Deve retornar uma lista de Product "
      'vazia quando houver uma falha', () {
    final uno = UnoMock(); // Cria uma instância de UnoMock com erro
    when(() => uno.get(any())).thenThrow(UnoError('Error'));

    final service = ApiService(
        uno); // Cria uma instância de ApiService com UnoMock com erro

    // Verifica se a chamada de getProducts retorna uma lista vazia em caso de erro
    expect(
      service.getProducts(),
      completion([]),
    );
  });
}

// Lista simulada de produtos em formato JSON
final productListJson = [
  {
    'id': 1,
    'title': 'title',
    'price': 12.0,
  },
  {
    'id': 2,
    'title': 'title2',
    'price': 13.0,
  },
];
