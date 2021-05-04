//
//  Database.swift
//  Capstone Project iOS
//
//  Created by Joeun Kim on 4/28/21.
//

import Foundation

class Database {
    static let instance: Database = Database()
    var uid:Int?
    
    init() {
    }
    static func getInstance() -> Database {
        return instance
    }

    // Fetch login result from Database. empty on failure
    func fetchLogin(login: String, password: String) -> (LoginModel?, MyError) {
        let param: NSDictionary = [
            "login": login,
            "password": password
        ]
        let (obj, err) = DatabaseConnection.fetchData("login", param)
        return (obj as? LoginModel, err)
    }

    // Fetch Patient Info for the passed patientID
    func fetchPatient(patientID: Int) -> (Patient?, MyError) {
        let param: NSDictionary = [
            "uid": patientID,
        ]
        let (obj, err) = DatabaseConnection.fetchData("u_profile", param)
        return (obj as? Patient, err)
    }

    // Fetch Provider Info with the passed providerID
    func fetchProvider(providerID: Int) -> (Provider?, MyError) {
        let param: NSDictionary = [
            "pid": providerID,
        ]
        let (obj, err) = DatabaseConnection.fetchData("p_profile", param)
        return (obj as? Provider, err)
    }

    // Fetch admin profile
    func fetchAdminInfo(adminID: Int) -> (Admin?, MyError) {
        let param: NSDictionary = [
            "aid": adminID,
        ]
        let (obj, err) = DatabaseConnection.fetchData("a_profile", param)
        return (obj as? Admin, err)
    }

    // Store patient information once signed up
    func regPatientInfo(withEmail email: String, password: String) -> MyError {
        var err:MyError, obj:NSObject?
        let patient = Patient(firstName: email)
        var param: NSDictionary = patient.toDict()
        (_, err) = DatabaseConnection.fetchData("u_reg", param)
        if err.code != 0 {return err}
        
        param = ["firstname": email]
        (obj, err) = DatabaseConnection.fetchData("u_query", param)
        if err.code != 0 {return err}
        if obj == nil {return MyError(1)}
        let patient2 = obj as! Patient
        let uid = patient2.uid
        
        param = [
            "login": email,
            "password": password,
            "targetid": uid
        ]
        (_, err) = DatabaseConnection.fetchData("u_newlogin", param)
        return err
    }
    
    // Store patient information after edit profile
    func storePatientInfo(_ patient: Patient) -> MyError {
        let param: NSDictionary = patient.toDict()
        let (_, err) = DatabaseConnection.fetchData("u_reg", param)
        return err
    }
    
    // Store provider information once signed up
    func regProviderInfo(withEmail email: String, password: String, org: String) -> MyError {
        var err:MyError, obj:NSObject?
        let provider = Provider(firstName: email, organizationName: org)
        var param: NSDictionary = provider.toDict()
        (_, err) = DatabaseConnection.fetchData("p_reg", param)
        if err.code != 0 {return err}
        
        param = ["firstname": email]
        (obj, err) = DatabaseConnection.fetchData("p_query", param)
        if err.code != 0 {return err}
        if obj == nil {return MyError(1)}
        let provider2 = obj as! Provider
        let uid = provider2.uid
        
        param = [
            "login": email,
            "password": password,
            "targetid": uid
        ]
        (_, err) = DatabaseConnection.fetchData("p_newlogin", param)
        return err
    }
    
    // Store provider information after edit profile
    func storeProviderInfo(_ provider: Provider) -> MyError {
        let param: NSDictionary = provider.toDict()
        let (_, err) = DatabaseConnection.fetchData("p_reg", param)
        return err
    }
    
    // Store coordinates(lat, lon) into Provider - it needs in order to calculate distance used in Find Provider
    func storeCoordinates(providerID: Int, lat: Float32, lng: Float32) -> MyError {
        let param: NSDictionary = [
            "pid": providerID,
            "lat": lat,
            "lng": lng
        ]
        let (_, err) = DatabaseConnection.fetchData("p_storecoord", param)
        return err
    }
    
    // Store record made by Provider
    // argument might be Record or
    // all of the class(Record) members except recordID (which db will generate in AI)
    func storeRecord(record: Record) -> MyError {
        let param: NSDictionary = record.toDict()
        let (_, err) = DatabaseConnection.fetchData("uv_done", param)
        return err
    }
    
    // Store appointment data made by Patient
    // argument might be Appointment or
    // all of the class(Appointment) members except appointmentID (which db will generate)
    func storeAppointment(appointment: Appointment) -> MyError {
        let param: NSDictionary = appointment.toDict()
        let (_, err) = DatabaseConnection.fetchData("o_new", param)
        return err
    }
    
    // Fetch open time slots on the given date set by passed paroviderID from Database
    func fetchOpenTimeSlotsFor(providerID: Int, date: Date) -> ([Date]?, MyError) {
        ////////
        // it's extremely hard for database to do such things...
        // could I return a list of appointed times so that you could calculate it in the app?
        ////////
        return (nil, MyError())
    }
    
    // Fetch Vaccination Records for the current user
    func fetchVaccinationRecordsForCurrentUser() -> ([Record]?, MyError) {
        ////////
        // if current user is patient then call fetchVaccinationRecordsForPatient
        // else if current user is provider then call fetchVaccinationRecordsForProvider
        ////////
        return (nil, MyError())
    }
    
    // Fetch Vaccination Records for the passed patientID
    func fetchVaccinationRecordsForPatient(patientID: Int) -> ([Record]?, MyError) {
        let param: NSDictionary = [
            "uid": patientID,
        ]
        let (obj, err) = DatabaseConnection.fetchData("uv_list", param)
        return (obj as? [Record], err)
    }
    
    // Fetch Vaccination Records for the passed providerID (and all patients?)
    func fetchVaccinationRecordsForProvider(providerID: Int) -> ([Record]?, MyError) {
        let param: NSDictionary = [
            "pid": providerID,
        ]
        let (obj, err) = DatabaseConnection.fetchData("puv_list", param)
        return (obj as? [Record], err)
    }
    
    // Fetch Vaccination Record with Details
    func fetchVaccinationRecordDetails(for recordID: Int) -> (Record?, MyError) {
        let param: NSDictionary = [
            "uvid": recordID,
        ]
        let (obj, err) = DatabaseConnection.fetchData("uv_detail", param)
        return (obj as? Record, err)
    }
    
    // Fetch Providers who offer the passsed service(vaccine or test)
    func fetchNearbyProviderListOffer(service: String) -> ([Provider]?, MyError) {
        // TBD
        return (nil, MyError())
    }
    
    // Fetch apointment list set to the passed patientID
    func fetchAppointmentListForPatient(patientID: Int) -> ([Appointment]?, MyError) {
        let param: NSDictionary = [
            "uid": patientID,
        ]
        let (obj, err) = DatabaseConnection.fetchData("uo_list", param)
        return (obj as? [Appointment], err)
    }
    
    // Fetch apointment list set to the passed providerID
    func fetchAppointmentListForProvider(providerID: Int) -> ([Appointment]?, MyError) {
        let param: NSDictionary = [
            "pid": providerID,
        ]
        let (obj, err) = DatabaseConnection.fetchData("po_list", param)
        return (obj as? [Appointment], err)
    }
    
    
    
    
}
