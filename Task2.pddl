;; task 2
;; in questo caso sono presenti due robot Shakey
;; i robot devono spostare tutti box in una stanza differente rispetto a quella iniziale
;; e devono terminare il problema nella stanza 4

(define (problem shakey-task-2)
    (:domain shakey)
    (:objects
        ;; static:
        room1 room2 room3 room4 corridor door1 door2 door3 door4 switch1 switch2 switch3 switch4
        ;; dynamic:
        shakey1 shakey2 box1 box2 box3 box4 box5 box6 box7
        ;;for EXTENDED-DOMAIN
        v0 void limited-container1 hand1 hand2
    )
    (:init
        ;; static:
        (shakey shakey1)
        (shakey shakey2)
        (room room1)
        (room room2)
        (room room3)
        (room room4)
        (box box1)
        (box box2)
        (box box3)
        (box box4)
        (box box5)
        (box box6)
        (box box7)
        (door door1)
        (door door2)
        (door door3)
        (door door4)
        (switch switch1)
        (switch switch2)
        (switch switch3)
        (switch switch4)
        (corridor corridor)
        (are-linked-by room1 corridor door1)
        (are-linked-by room2 corridor door2)
        (are-linked-by room3 corridor door3)
        (are-linked-by room4 corridor door4)
        (is-in switch1 room1)
        (is-in switch2 room2)
        (is-in switch3 room3)
        (is-in switch4 room4)

        ;; dynamic:
        (is-on-floor shakey1)
        (is-on-floor shakey2)
        (is-in box1 room1)
        (is-in box2 room2)
        (is-in box3 room2)
        (is-in box4 room3)
        (is-in box5 room3)
        (is-in box6 room4)
        (is-in box7 room1)
        (is-in shakey1 room3)
        (is-in shakey2 room2)
        (off switch1)
        (lit switch2)
        (off switch4)
        (lit switch3)
        
        ;;for EXTENDED-DOMAIN
        (at v0 limited-container1)
        (clear void box1)
        (hand shakey1 hand1)
        (empty hand1)
        (hand shakey2 hand2)
        (empty hand2)
    )
    (:goal
        (and
            (is-in box1 room2)
            (is-in box2 room3)
            (is-in box3 room1)
            (is-in box4 room4)
            (is-in box5 room1)
            (is-in box6 room2)
            (is-in box7 room3)
            (is-in shakey1 room4)
            (is-in shakey2 room4)
        )
    )
)