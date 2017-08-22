//
//  FlightsDataSource.swift
//  SpeechRecognitionDemo
//
//  Created by Patrick Balestra on 1/6/17.
//  Copyright © 2017 Patrick Balestra. All rights reserved.
//

import Foundation

struct Flight {
    let number: String
    let status: String
}

class FlightsDataSource {

    static var flights: [Flight] = {
        return [
            Flight(number: "Me van a cobrar membresía", status: "Claro que no Antonio, cumpliste todas las metas"),
            Flight(number: "No me ha llegado mi estado de cuenta", status: "Te lo acabo de reenviar a antoniocachuan@gmail.com"),
            Flight(number: "BCP mi mejor amigo", status: "Siempre buscamos clientes contentos."),
            Flight(number: "Cómo estás", status: "Muy bien, gracias."),
            Flight(number: "Qué día es hoy", status: "Hoy ganaremos la Hackathon 'BCP'"),
            Flight(number: "Reclamo 06", status: "Estado de cuenta"),
            Flight(number: "Reclamo 07", status: "Intereses"),
            Flight(number: "Reclamo 08", status: "Depósitos a plazo"),
            Flight(number: "Reclamo 09", status: "Fondos Mutuos"),
            Flight(number: "Reclamo 10", status: "Trato descortés"),
            Flight(number: "Reclamo 11", status: "Abuso de autoridad"),
            Flight(number: "Reclamo 12", status: "Mal servicio"),
            Flight(number: "Reclamo 13", status: "Cajeros malogrados"),
            Flight(number: "Reclamo 14", status: "Cierre cuenta"),
            Flight(number: "Reclamo 15", status: "Otros")
        ]
    }()

    static func searchFlight(number: String) -> Flight? {
        return flights.filter { number.contains($0.number) }.first
    }
}
