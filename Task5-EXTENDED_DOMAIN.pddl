;;Shakey deve inserire 20 forme di tetris ordinandole su 5 piani differenti
;;e dovrà accendere la luce della stanza numero 4

(define (problem shakey-task-5)
            (:domain shakey)
            (:objects
                ;; static:
                room1 room2 room3 room4 corridor door1 door2 door3 door4 switch1 switch2 switch3 switch4
                ;; dynamic:
                shakey box1 box2 box3 box4 hand limited-container1 limited-container2 void
                tetris-piece1 tetris-piece2 tetris-piece3 tetris-piece4 tetris-piece5 tetris-piece6 tetris-piece7 tetris-piece8 tetris-piece9 tetris-piece10 tetris-piece11
                tetris-piece12 tetris-piece13 tetris-piece14 tetris-piece15 tetris-piece16 tetris-piece17 tetris-piece18 tetris-piece19 tetris-piece20
                ;; container level
                v0 v1 v2 v3 v4 v5
            )
            (:init
                ;; static:
                (shakey shakey)
                (room room1) (room room2) (room room3) (room room4)
                (box box1) (box box2) (box box3)
                (final-box box4)
                (hand shakey hand)
                (door door1) (door door2) (door door3) (door door4)
                (switch switch1) (switch switch2) (switch switch3) (switch switch4)
                (corridor corridor)
                (limited-container limited-container1)
                (limited-container limited-container2)
                (are-linked-by room1 corridor door1)
                (are-linked-by room2 corridor door2)
                (are-linked-by room3 corridor door3)
                (are-linked-by room4 corridor door4)
                (is-in switch1 room1)
                (is-in switch2 room2)
                (is-in switch3 room3)
                (is-in switch4 room4)
                (tetris-piece tetris-piece1) (tetris-piece tetris-piece2) (tetris-piece tetris-piece3) (tetris-piece tetris-piece4) (tetris-piece tetris-piece5)
                (tetris-piece tetris-piece6) (tetris-piece tetris-piece7) (tetris-piece tetris-piece8) (tetris-piece tetris-piece9) (tetris-piece tetris-piece10) 
                (tetris-piece tetris-piece11) (tetris-piece tetris-piece12) (tetris-piece tetris-piece13) (tetris-piece tetris-piece14)(tetris-piece void)
                (tetris-piece tetris-piece15) (tetris-piece tetris-piece16) (tetris-piece tetris-piece17) (tetris-piece tetris-piece18) (tetris-piece tetris-piece19) (tetris-piece tetris-piece20)
                
                ;; dynamic:
                (is-on-floor shakey)
                (is-in box1 room2)
                (is-in box2 room1)
                (is-in box3 room1)
                (is-in box4 room4)
                (is-in limited-container1 room4)
                (is-in limited-container2 room4)
                (is-in shakey room1)
                (lit switch1)
                (off switch2)
                (off switch4)
                (lit switch3)
                
                (putted-zero-piece box4)
                (empty hand)
                (at v0 limited-container1)
                (at v0 limited-container2)
                (inc v0 v1) (inc v1 v2) (inc v2 v3) (inc v3 v4) (inc v4 v5)
                (dec v1 v0) (dec v2 v1) (dec v3 v2) (dec v4 v3) (dec v5 v4)
                
                (form1 tetris-piece1) (form1 tetris-piece2) (form1 tetris-piece20) (form1 tetris-piece18) (form1 tetris-piece15)
                (form2 tetris-piece3) (form2 tetris-piece4) (form2 tetris-piece19)
                (form3 tetris-piece5) (form3 tetris-piece6) (form3 tetris-piece12) (form3 tetris-piece13) (form3 tetris-piece14) (form3 tetris-piece16)
                (form4 tetris-piece7) (form4 tetris-piece8)
                (form5 tetris-piece9) (form5 tetris-piece10) (form5 tetris-piece11) (form5 tetris-piece17)
                 
                (not (used tetris-piece1)) (not (used tetris-piece2)) (not (used tetris-piece3)) (not (used tetris-piece4)) (not (used tetris-piece5))
                (not (used tetris-piece6)) (not (used tetris-piece7)) (not (used tetris-piece8)) (not (used tetris-piece9)) (not (used tetris-piece10))
                (not (used tetris-piece11)) (not (used tetris-piece12)) (not (used tetris-piece13)) (not (used tetris-piece14)) (not (used tetris-piece15))
                (not (used tetris-piece16)) (not (used tetris-piece17)) (not (used tetris-piece18)) (not (used tetris-piece19)) (not (used tetris-piece20))
                
                (clear tetris-piece1 box1) (on tetris-piece1 tetris-piece2 box1) (on tetris-piece2 tetris-piece11 box1) (on tetris-piece11 tetris-piece9 box1) (on tetris-piece9 tetris-piece20 box1) (on tetris-piece20 tetris-piece13 box1) (on tetris-piece13 tetris-piece16 box1) (on tetris-piece16 tetris-piece10 box1) (on tetris-piece10 tetris-piece17 box1) (on tetris-piece17 void box1)
                (clear tetris-piece3 box2) (on tetris-piece3 tetris-piece4 box2) (on tetris-piece4 tetris-piece19 box2) (on tetris-piece19 tetris-piece12 box2)  (on tetris-piece12 tetris-piece5 box2) (on tetris-piece5 tetris-piece18 box2) (on tetris-piece18 tetris-piece14 box2) (on tetris-piece14 tetris-piece8 box2) (on tetris-piece8 tetris-piece15 box2) (on tetris-piece15 tetris-piece6 box2) (on tetris-piece6 tetris-piece7 box2) (on tetris-piece7 void box2)
            )
            (:goal (and
                (lit switch4)
                (out tetris-piece1)
                (out tetris-piece2)
                (out tetris-piece3)
                (out tetris-piece4)
                (out tetris-piece5)
                (out tetris-piece6)
                (out tetris-piece7)
                (out tetris-piece8)
                (out tetris-piece9)
                (out tetris-piece10)
                (out tetris-piece11)
                (out tetris-piece12)
                (out tetris-piece13)
                (out tetris-piece14)
                (out tetris-piece15)
                (out tetris-piece16)
                (out tetris-piece17)
                (out tetris-piece18)
                (out tetris-piece19)
                (out tetris-piece20))
                )
)