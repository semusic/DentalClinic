package com.dentalclinic.pattern.observer;

import com.dentalclinic.model.Notification;
import org.junit.Test;

import static org.junit.Assert.*;

public class NotificationSubjectTest {

    @Test
    public void shouldNotifyAttachedObserver() {

        NotificationSubject subject =
                new NotificationSubject();

        TestObserver observer =
                new TestObserver();

        subject.attach(observer);

        subject.notifyObservers(
                new Notification()
        );

        assertEquals(
                1,
                observer.getNotificationCount()
        );
    }

    @Test
    public void shouldNotNotifyDetachedObserver() {

        NotificationSubject subject =
                new NotificationSubject();

        TestObserver observer =
                new TestObserver();

        subject.attach(observer);
        subject.detach(observer);

        subject.notifyObservers(
                new Notification()
        );

        assertEquals(
                0,
                observer.getNotificationCount()
        );
    }

    @Test
    public void shouldNotAttachSameObserverTwice() {

        NotificationSubject subject =
                new NotificationSubject();

        TestObserver observer =
                new TestObserver();

        subject.attach(observer);
        subject.attach(observer);

        subject.notifyObservers(
                new Notification()
        );

        assertEquals(
                1,
                observer.getNotificationCount()
        );
    }

    @Test
    public void shouldIgnoreNullObserver() {

        NotificationSubject subject =
                new NotificationSubject();

        subject.attach(null);

        TestObserver observer =
                new TestObserver();

        subject.attach(observer);

        subject.notifyObservers(
                new Notification()
        );

        assertEquals(
                1,
                observer.getNotificationCount()
        );
    }

    /**
     * Simple test observer used only for this unit test.
     */
    private static class TestObserver
            implements NotificationObserver {

        private int notificationCount = 0;

        @Override
        public void onNotification(
                Notification notification) {

            notificationCount++;
        }

        public int getNotificationCount() {
            return notificationCount;
        }
    }
}