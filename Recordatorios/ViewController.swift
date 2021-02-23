//
//  ViewController.swift
//  Recordatorios
//
//  Created by marco rodriguez on 23/02/21.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet var table: UITableView!

    var models = [MyRecordatorio]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].tittle
        let date = models[indexPath.row].date
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        
        //convertir a string
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
    
    //MARK:- Botones
    @IBAction func addButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddRecordatorioViewController else {
        return
    }
    
    vc.title = "NUevo recordatorio"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body, date in
            //Regresar al menu principal
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let nuevo = MyRecordatorio(tittle: title, date: date, id: "id_\(title)")
                self.models.append(nuevo)
                self.table.reloadData()
                
                let contenido = UNMutableNotificationContent()
                contenido.title = title
                contenido.sound = .default
                contenido.body = body
                
                let fechaRecordar = date
                let disparador = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute,. second], from: fechaRecordar), repeats: false)
                
                //realizar la solicitud de notificacion
                let request = UNNotificationRequest(identifier: "some_long_id", content: contenido, trigger: disparador)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("Algo ocurrio mal")
                    }
                })
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func probarButton() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { [self] succes, error in
            
            if succes {
                //  Prueba de horario
                self.probarHorario()
                
            } else if error != nil {
                print("ocurrio un error")
            }
        })
    }
    
    func probarHorario(){
        let contenido = UNMutableNotificationContent()
        contenido.title = "Es hora de hacer tu tarea"
        contenido.sound = .default
        contenido.body = "Recuenda hacer lo que programaste en el recordatorio"
        
        let fechaRecordar = Date().addingTimeInterval(10)
        let disparador = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute,. second], from: fechaRecordar), repeats: false)
        
        //realizar la solicitud de notificacion
        let request = UNNotificationRequest(identifier: "some_long_id", content: contenido, trigger: disparador)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("Algo ocurrio mal")
            }
        })
        
    }
    
}

struct MyRecordatorio {
    let tittle: String
    let date: Date
    let id: String
}
