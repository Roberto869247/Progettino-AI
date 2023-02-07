(define (domain shakey)
    (:requirements :strips)

    (:predicates
        (room ?room)
        (shakey ?shakey)
        (corridor ?corridor)
        (box ?box)
        (door ?door)
        (switch ?switch)
    
        (are-linked-by ?room ?corridor ?door)
        (is-in ?any-obj ?room)
        (is-on ?shakey ?box)
        (is-on-floor ?shakey)
    
        (lit ?switch)
        (off ?switch)
        
        (is-under-switch ?box ?room)
    )
    
    (:action shakey_changes_room
    :parameters (?shakey ?room-a ?door-a ?room-b ?door-b ?corridor )
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room-a)
        (room ?room-a)
        (room ?room-b)
        (are-linked-by ?room-a ?corridor ?door-a)
        (are-linked-by ?room-b ?corridor ?door-b)
        (corridor ?corridor)
        (door ?door-a)
        (door ?door-b)
    )
    :effect (and
        (is-in ?shakey ?room-b)
        (not (is-in ?shakey ?room-a))
        )
    )
    
    (:action shakey_pushes_box_between_rooms
    :parameters (?shakey ?box ?room-a ?door-a ?room-b ?door-b ?corridor)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room-a)
        (room ?room-a)
        (room ?room-b)
        (box ?box)
        (is-in ?box ?room-a)
        (are-linked-by ?room-a ?corridor ?door-a)
        (are-linked-by ?room-b ?corridor ?door-b)
        (corridor ?corridor)
        (door ?door-a)
        (door ?door-b)
    )
    :effect (and
        (is-in ?shakey ?room-b)
        (not (is-in ?shakey ?room-a))
        (is-in ?box ?room-b)
        (not (is-in ?box ?room-a))
        (not (is-under-switch ?box ?room-a))
        )
    )
    
    (:action shakey_climbs_on_the_box
    :parameters (?shakey ?box ?room)
    :precondition (and
        (shakey ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (box ?box)
        (is-in ?box ?room)
        (is-on-floor ?shakey)
    )
    :effect (and
        (is-on ?shakey ?box)
        (not (is-on-floor ?shakey))
        )
    )
    
    (:action shakey_gets_out_the_box
    :parameters (?shakey ?box ?room)
    :precondition (and
        (shakey ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (box ?box)
        (is-in ?box ?room)
        (is-on ?shakey ?box)
    )
    :effect (and
        (is-on-floor ?shakey)
        (not (is-on ?shakey ?box))
        )
    )
    
    (:action shakey_turns_on_the_light
    :parameters (?shakey ?box ?room ?switch)
    :precondition (and
        (shakey ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (is-in ?switch ?room)
        (switch ?switch)
        (off ?switch)
        (is-on ?shakey ?box)
        (box ?box)
        (is-in ?box ?room)
        (is-under-switch ?box ?room)
    )
    :effect (and
        (lit ?switch)
        (not (off ?switch))
        )
    )
    
    (:action shakey_turns_off_the_light
    :parameters (?shakey ?box ?room ?switch)
    :precondition (and
        (shakey ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (is-in ?switch ?room)
        (switch ?switch)
        (lit ?switch)
        (is-on ?shakey ?box)
        (box ?box)
        (is-in ?box ?room)
        (is-under-switch ?box ?room)
    )
    :effect (and
        (off ?switch)
        (not (lit ?switch))
        )
    )
    
    (:action shakey_pushes_box_under_switch
    :parameters (?shakey ?box ?room)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (box ?box)
        (is-in ?box ?room)
    )
    :effect 
        (is-under-switch ?box ?room)
    )
)