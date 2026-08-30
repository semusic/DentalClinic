package com.dentalclinic.pattern.chain;

public class AppointmentValidationChain {

    private final AppointmentValidationHandler firstHandler;

    public AppointmentValidationChain() {

        AppointmentValidationHandler basic =
                new BasicAppointmentValidationHandler();

        AppointmentValidationHandler patient =
                new PatientExistenceValidationHandler();

        AppointmentValidationHandler service =
                new ServiceAvailabilityValidationHandler();

        AppointmentValidationHandler doctorService =
                new DoctorServiceValidationHandler();

        AppointmentValidationHandler schedule =
                new DoctorScheduleValidationHandler();

        AppointmentValidationHandler conflict =
                new AppointmentConflictValidationHandler();

        basic.setNext(patient);
        patient.setNext(service);
        service.setNext(doctorService);
        doctorService.setNext(schedule);
        schedule.setNext(conflict);

        this.firstHandler = basic;
    }

    public AppointmentValidationHandler getFirstHandler() {
        return firstHandler;
    }
}