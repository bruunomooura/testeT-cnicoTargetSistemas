import Foundation

// MARK: - Item 1

/**
 Função que calcula a soma dos números inteiros de 1 até um índice especificado.
 A variável `indice` define o limite superior, e a variável `soma` acumula a soma dos números.
 */
private let indice: Int = 13
private var soma: Int = 0
private var k: Int = 0

while k < indice {
    k += 1
    soma += k
}
print("Sum is equal to: \(soma)")

// MARK: - Item 2

/**
 Função que verifica se um número pertence à sequência de Fibonacci.
 A sequência de Fibonacci inicia com 0 e 1, e cada número subsequente é a soma dos dois números anteriores.
 A função imprime uma mensagem indicando se o número informado pertence ou não à sequência.
 
 - Parameter value: O número a ser verificado.
 */
func checkValueBelongsToFibonacci(value: Int) {
    var a: Int = 0
    var b: Int = 1
    
    if value == a || value == b {
        print("The number \(value) belongs to the Fibonacci sequence.")
        return
    }
    while b < value {
        let nextValue: Int = a + b
        
        a = b
        b = nextValue
        
        if b == value {
            print("The number \(value) belongs to the Fibonacci sequence.")
            return
        }
    }
    print("The number \(value) does not belong to the Fibonacci sequence.")
}

checkValueBelongsToFibonacci(value: 21)

// MARK: - Item 3

/**
 Estrutura que representa o faturamento diário de um dia específico.
 A conformidade com o protocolo `Decodable` permite a decodificação de dados JSON para a estrutura.
 */
struct DailyRevenue: Decodable {
    let day: Int
    let revenue: Double
}

/**
 Função que calcula estatísticas de faturamento a partir de um array de dados de faturamento diário.
 Calcula o menor e maior valor de faturamento do mês, a média mensal, e o número de dias com faturamento acima da média.
 
 - Parameter revenue: Um array de `DailyRevenue` representando os dados de faturamento diário.
 */
func calculateRevenueStatistics(revenue: [DailyRevenue]) {
    let revenueValidDays = revenue.filter { $0.revenue > 0 }
    
    guard !revenueValidDays.isEmpty else {
        print("There is no valid revenue data.")
        return
    }
    
    let lowestRevenueOfTheMonth = revenueValidDays.min(by: { $0.revenue < $1.revenue })?.revenue ?? 0
    let highestRevenueOfTheMonth = revenueValidDays.max(by: { $0.revenue < $1.revenue})?.revenue ?? 0
    
    let totalMonthlyRevenue = revenueValidDays.reduce(0) { $0 + $1.revenue }
    let averageMonthlyRevenue = totalMonthlyRevenue / Double(revenueValidDays.count)
    
    let daysRevenueAboveAverage = revenueValidDays.filter { $0.revenue > averageMonthlyRevenue }.count
    
    print("The lowest billing amount occurred on a day of the month was \(lowestRevenueOfTheMonth)")
    print("The highest billing amount occurred on a day of the month was \(highestRevenueOfTheMonth)")
    print("Number of days in the month in which the daily billing amount was higher than the monthly average \(daysRevenueAboveAverage)")
}

/**
 Enum que define os nomes dos arquivos JSON usados para leitura dos dados de faturamento.
 */
enum JSONFile: String {
    case revenueData = "Revenue"
    case json = "json"
}

/**
 Função que lê e processa os dados de faturamento a partir de um arquivo JSON.
 Usa `JSONDecoder` para decodificar os dados em um array de `DailyRevenue`.
 
 - Parameter completion: Um closure que é chamado com o resultado da leitura e decodificação dos dados.
 */
func readAndProcessTheRevenueData(completion: @escaping (Result<[DailyRevenue], any Error>) -> Void) {
    guard let url = Bundle.main.url(forResource: JSONFile.revenueData.rawValue, withExtension: JSONFile.json.rawValue) else {
        print("Unable to find the file.")
        return
    }
    
    do {
        let data = try Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        let daysRevenue: [DailyRevenue] = try jsonDecoder.decode([DailyRevenue].self, from: data)
        completion(.success(daysRevenue))
    } catch {
        print("There is no valid revenue data.")
        completion(.failure(error))
    }
}

readAndProcessTheRevenueData { result in
    switch result {
    case .success(let daysRevenue):
        calculateRevenueStatistics(revenue: daysRevenue)
        
    case .failure(let error):
        print("Failed to decode file, error: \(error.localizedDescription)")
    }
}

// MARK: - Item 4

/**
 Dicionário que armazena o faturamento mensal detalhado por estado.
 */
let revenueDataByState: [String : Double] = [
    "SP": 67836.43,
    "RJ": 36678.66,
    "MG": 29229.88,
    "ES": 27165.48,
    "Outros": 19849.53
]

/**
 Função que calcula e imprime a porcentagem de representação do faturamento de cada estado no faturamento total da distribuidora.
 */
func calculateTheRepresentationOfTheStatesRevenue() {
    let totalRevenue = revenueDataByState.values.reduce(0) { $0 + $1 }
    
    for (state, revenue) in revenueDataByState {
        let representationOnRevenue = (revenue / totalRevenue ) * 100
        print("Estado: \(state), Percentual de Representação: \(String(format: "%.2f", representationOnRevenue))%")
    }
}

calculateTheRepresentationOfTheStatesRevenue()

// MARK: - Item 5

/**
 Função que inverte os caracteres de uma string e retorna a string invertida.
 
 - Parameter string: A string original que será invertida.
 - Returns: A string com os caracteres invertidos.
 */
func reverseStringCharacters(_ string: String) -> String {
    let characters = Array(string)
    var reversedString: String = .init()
    
    for i in stride(from: characters.count - 1, through: 0, by: -1) {
        reversedString.append(characters[i])
    }
    return reversedString
}

let originalString: String = "Bruno de Moura"
let reversedString = reverseStringCharacters(originalString)

print("Original: \(originalString)")
print("Reversed: \(reversedString)")
