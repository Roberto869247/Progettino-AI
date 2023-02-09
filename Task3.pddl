;; task 3
;; Shakey deve accedere gli interruttori che sono spenti e viceversa
;; e deve terminare il problema posizionandosi nella stanza 1
(define (problem shakey-task-3)
    (:domain shakey)
    (:objects
        ;; static:
        room1 room2 room3 room4 corridor door1 door2 door3 door4 switch1 switch2 switch3 switch4
        ;; dynamic:
        shakey box1 box2 box3 box4
        ;;for EXTENDED-DOMAIN
        v0 void limited-container1 hand
    )
    (:init
        ;; static:
        (shakey shakey)
        (room room1)
        (room room2)
        (room room3)
        (room room4)
        (box box1)
        (box box2)
        (box box3)
        (box box4)
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
        (is-on-floor shakey)
        (is-in box1 room1)
        (is-in box2 room2)
        (is-in box3 room2)
        (is-in box4 room3)
        (is-in shakey room3)
        (lit switch1)
        (off switch2)
        (off switch4)
        (lit switch3)
        
        ;;for EXTENDED-DOMAIN
        (at v0 limited-container1)
        (clear void box1)
        (hand shakey hand)
        (empty hand)
    )
    (:goal
        (and
            (off switch1)
            (lit switch2)
            (lit switch4)
            (off switch3)
            (is-in shakey room1)
        )
    )
)