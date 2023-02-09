(define (domain shakey)
    (:requirements :strips)

    (:predicates
        (room ?room)                     ;;oggetti di tipo stanza
        (shakey ?shakey)                 ;;oggetti di tipo shakey
        (corridor ?corridor)             ;;oggetti di tipo corridoio
        (box ?box)                       ;;oggetti di tipo box
        (door ?door)                     ;;oggetti di tipo porta
        (switch ?switch)                 ;;oggetti di tipo interruttore
     
        (are-linked-by ?room ?corridor ?door)   ;;serve per creare il mondo di shakey dichiarandon quali stanze sono collegate e da cosa
        (is-in ?any-obj1 ?any-obj2)             ;;serve per indicare gli oggetti contenuti in altri oggetti
        (is-on ?shakey ?box)                    ;;indica che shakey è sopra una scatola
        (is-on-floor ?shakey)                   ;;indica che shakey è sul pavimento
    
        (lit ?switch)                      ;luce accesa
        (off ?switch)                      ;;luce spenta
          
        (is-under-switch ?box ?room)       ;;indica che la scatola si trova sotto l'interruttore
        
        ;; ESTENSIONE
        (hand ?shakey ?hand)               ;;mano del robot
        (limited-container ?container)     ;;contenitori limitati aggiuntivi
        (empty ?hand)                      ;;la mano può essere occupata o libera
        (final-box ?box)                   ;;scatola nel quale creare i piani delle figure
        (at ?x ?container)                 ;;indice del livello di riempimento dei contenitori limitati
        (inc ?x ?xp)                       ;;serve per incrementare l'indice del livello di riempimento dei contenitori limitati
        (dec ?x ?xn)                       ;;serve per diminuire l'indice del livello di riempimento dei contenitori limitati
        
        (putted-zero-piece ?final-box)     ;;serve per monitorare il numero di pezzi inseriti nel box finale
        (putted-one-piece ?final-box)      ;;serve per monitorare il numero di pezzi inseriti nel box finale
        (putted-two-piece ?final-box)      ;;serve per monitorare il numero di pezzi inseriti nel box finale
        (putted-three-piece ?final-box)    ;;serve per monitorare il numero di pezzi inseriti nel box finale
        (putted-four-piece ?final-box)     ;;serve per monitorare il numero di pezzi inseriti nel box finale

        ;;tutte le figure occupano 4 caselle
        ;;il box è rappresentabile da una matrice 4X4 
        ;;nel box è necessario inserire 4 figure per completare un piano
        ;;è possibile non completare l'ultimo livello inserendo al massimo le ultime due figure rimaste
        ;;le figure vengono estratte dai box1 e box2 seguendo l'ordine di come sono state inizializzate
        ;;sarà possibile estrarre solo la figura che non ha altre figure al di sopra
        
        (tetris-piece ?piece)    ;; figura generico, non è necessario sapere quale
        (form1 ?piece)   ;; figura diritta 
        (form2 ?piece)   ;; figura quadrata
        (form3 ?piece)   ;; figura che replica la "mossa del cavallo" negli scacchi
        (form4 ?piece)   ;; figura a forma di S
        (form5 ?piece)   ;; ultima figura rimasta
        (used ?piece)    ;;figura utilizzata nel ciclo di validazione di un livello
        (on ?piece-a ?piece-b ?box)  ;;posizione della figura nei box di partenza
        (clear ?piece ?box)  ;;prima figura nel box di partenza
        (out ?piece)         ;; il pezzo è stato sigillato nel livello
    )
    
    (:action take_a_piece_from_box                                 ;;per prendere un pezzo da uno dei due box iniziali
    :parameters (?shakey ?room ?box ?piece-a ?hand ?piece-b)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (hand ?shakey ?hand)
        (is-in ?box ?room)
        (box ?box)
        (tetris-piece ?piece-a)
        (on ?piece-a ?piece-b ?box)
        (empty ?hand)
        (clear ?piece-a ?box)
    )
    :effect (and
        (not (empty ?hand))
        (is-in ?piece-a ?hand)
        (not (on ?piece-a ?piece-b ?box))
        (not (clear ?piece-a ?box))
        (clear ?piece-b ?box)
        )
    )
    
    (:action deposit_a_piece_in_container                        ;;per depositare un pezzo che shakey ha in mano in unoo dei due container, controllando che non siano pieni
    :parameters (?shakey ?room ?container ?piece ?hand ?x ?xp)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (hand ?shakey ?hand)
        (is-in ?container ?room)
        (limited-container ?container)
        (tetris-piece ?piece)
        (not (empty ?hand))
        (is-in ?piece ?hand)
        (at ?x ?container)
        (inc ?x ?xp)
    )
    :effect (and
        (empty ?hand)
        (is-in ?piece ?container)
        (not (is-in ?piece ?hand))
        (at ?xp ?container)
        (not (at ?x ?container))
        )
    )
    
    (:action take_a_piece_from_container                       ;;per prendere un pezzo da uno dei due container
    :parameters (?shakey ?room ?container ?piece ?hand ?x ?xn)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (hand ?shakey ?hand)
        (is-in ?container ?room)
        (limited-container ?container)
        (tetris-piece ?piece)
        (empty ?hand)
        (is-in ?piece ?container)
        (at ?x ?container)
        (dec ?x ?xn)
    )
    :effect (and
        (not (empty ?hand))
        (is-in ?piece ?hand)
        (not (is-in ?piece ?container))
        (at ?xn ?container)
        (not (at ?x ?container))
        )
    )
    
    (:action deposit_first_piece_in_box                      ;;per depositare la prima forma della scatola finale
    :parameters (?shakey ?room ?box ?piece ?hand)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (hand ?shakey ?hand)
        (is-in ?box ?room)
        (final-box ?box)
        (tetris-piece ?piece)
        (not (empty ?hand))
        (is-in ?piece ?hand)
        (putted-zero-piece ?box)
        (not (used ?piece))
    )
    :effect (and
        (empty ?hand)
        (is-in ?piece ?box)
        (used ?piece)
        (not (is-in ?piece ?hand))
        (not (putted-zero-piece ?box))
        (putted-one-piece ?box))
    )

    
    (:action deposit_second_piece_in_box                      ;;per depositare la seconda forma della scatola finale
    :parameters (?shakey ?room ?box ?piece ?hand)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (hand ?shakey ?hand)
        (is-in ?box ?room)
        (final-box ?box)
        (tetris-piece ?piece)
        (not (empty ?hand))
        (is-in ?piece ?hand)
        (not (used ?piece))
        (putted-one-piece ?box)
    )
    :effect (and
        (empty ?hand)
        (is-in ?piece ?box)
        (used ?piece)
        (not (is-in ?piece ?hand))
        (not (putted-one-piece ?box))
        (putted-two-piece ?box))
    )
    
    (:action deposit_third_piece_in_box                     ;;per depositare la terza forma della scatola finale
    :parameters (?shakey ?room ?box ?piece ?hand)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (hand ?shakey ?hand)
        (is-in ?box ?room)
        (final-box ?box)
        (tetris-piece ?piece)
        (not (empty ?hand))
        (not (used ?piece))
        (is-in ?piece ?hand)
        (putted-two-piece ?box)
    )
    :effect (and
        (empty ?hand)
        (is-in ?piece ?box)
        (used ?piece)
        (not (is-in ?piece ?hand))
        (not (putted-two-piece ?box))
        (putted-three-piece ?box))
    )
    
    (:action deposit_fourth_piece_in_box                   ;;per depositare la quarta forma della scatola finale
    :parameters (?shakey ?room ?box ?piece ?hand)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (hand ?shakey ?hand)
        (is-in ?box ?room)
        (final-box ?box)
        (tetris-piece ?piece)
        (not (empty ?hand))
        (not (used ?piece))
        (is-in ?piece ?hand)
        (putted-three-piece ?box)
    )
    :effect (and
        (empty ?hand)
        (is-in ?piece ?box)
        (used ?piece)
        (not (is-in ?piece ?hand))
        (not (putted-three-piece ?box))
        (putted-four-piece ?box))
    )
    
    (:action complete_a_level1                                          ;;sigillare un livello una volta che è stato completato correttamente
    :parameters (?shakey ?room ?box ?piece-a ?piece-b ?piece-c ?piece-d)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (is-in ?box ?room)
        (final-box ?box)
        (putted-four-piece ?box)
        (not (= ?piece-a ?piece-b))
        (not (= ?piece-b ?piece-c))
        (not (= ?piece-a ?piece-d))
        (not (= ?piece-b ?piece-d))
        (not (= ?piece-c ?piece-d))
        (not (= ?piece-a ?piece-c))
        (used ?piece-a)
        (used ?piece-b)
        (used ?piece-c)
        (used ?piece-d)
        (form1 ?piece-a)                                         ;;indico la combinazione di forme che devono essere inserite per completare un livello alla volta
        (form1 ?piece-b)                                         ;;ho 9 differenti combinazioni possibili di forme per completare un livello e andare avanti
        (form1 ?piece-c)
        (form1 ?piece-d))
    :effect(and
        (not (putted-four-piece ?box))
        (putted-zero-piece ?box)
        (not (used ?piece-a))
        (not (used ?piece-b))
        (not (used ?piece-c))
        (not (used ?piece-d))
        (out ?piece-a)
        (out ?piece-b)
        (out ?piece-c)
        (out ?piece-d)
        )
    )
    (:action complete_a_level2
    :parameters (?shakey ?room ?box ?piece-a ?piece-b ?piece-c ?piece-d)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (is-in ?box ?room)
        (final-box ?box)
        (putted-four-piece ?box)
        (not (= ?piece-a ?piece-b))
        (not (= ?piece-b ?piece-c))
        (not (= ?piece-a ?piece-d))
        (not (= ?piece-b ?piece-d))
        (not (= ?piece-c ?piece-d))
        (not (= ?piece-a ?piece-c))
        (used ?piece-a)
        (used ?piece-b)
        (used ?piece-c)
        (used ?piece-d)
        (form2 ?piece-a)
        (form2 ?piece-b)
        (form2 ?piece-c)
        (form2 ?piece-d))
    :effect(and
        (not (putted-four-piece ?box))
        (putted-zero-piece ?box)
        (not (used ?piece-a))
        (not (used ?piece-b))
        (not (used ?piece-c))
        (not (used ?piece-d))
        (out ?piece-a)
        (out ?piece-b)
        (out ?piece-c)
        (out ?piece-d)
        )
    )
    (:action complete_a_level3
    :parameters (?shakey ?room ?box ?piece-a ?piece-b ?piece-c ?piece-d)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (is-in ?box ?room)
        (final-box ?box)
        (putted-four-piece ?box)
        (not (= ?piece-a ?piece-b))
        (not (= ?piece-c ?piece-d))
        (used ?piece-a)
        (used ?piece-b)
        (used ?piece-c)
        (used ?piece-d)
        (form1 ?piece-a)
        (form1 ?piece-b)
        (form2 ?piece-c)
        (form2 ?piece-d))
    :effect(and
        (not (putted-four-piece ?box))
        (putted-zero-piece ?box)
        (not (used ?piece-a))
        (not (used ?piece-b))
        (not (used ?piece-c))
        (not (used ?piece-d))
        (out ?piece-a)
        (out ?piece-b)
        (out ?piece-c)
        (out ?piece-d)
        )
    )
    (:action complete_a_level4
    :parameters (?shakey ?room ?box ?piece-a ?piece-b ?piece-c ?piece-d)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (is-in ?box ?room)
        (final-box ?box)
        (putted-four-piece ?box)
        (not (= ?piece-a ?piece-b))
        (not (= ?piece-c ?piece-d))
        (used ?piece-a)
        (used ?piece-b)
        (used ?piece-c)
        (used ?piece-d)
        (form2 ?piece-a)
        (form2 ?piece-b)
        (form3 ?piece-c)
        (form3 ?piece-d))
    :effect(and
        (not (putted-four-piece ?box))
        (putted-zero-piece ?box)
        (not (used ?piece-a))
        (not (used ?piece-b))
        (not (used ?piece-c))
        (not (used ?piece-d))
        (out ?piece-a)
        (out ?piece-b)
        (out ?piece-c)
        (out ?piece-d)
        )
    )
    (:action complete_a_level5
    :parameters (?shakey ?room ?box ?piece-a ?piece-b ?piece-c ?piece-d)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (is-in ?box ?room)
        (final-box ?box)
        (putted-four-piece ?box)
        (not (= ?piece-a ?piece-c))
        (used ?piece-a)
        (used ?piece-b)
        (used ?piece-c)
        (used ?piece-d)
        (form5 ?piece-a)
        (form3 ?piece-b)
        (form5 ?piece-c)
        (form1 ?piece-d))
    :effect(and
        (not (putted-four-piece ?box))
        (putted-zero-piece ?box)
        (not (used ?piece-a))
        (not (used ?piece-b))
        (not (used ?piece-c))
        (not (used ?piece-d))
        (out ?piece-a)
        (out ?piece-b)
        (out ?piece-c)
        (out ?piece-d)
        )
    )
    (:action complete_a_level6
    :parameters (?shakey ?room ?box ?piece-a ?piece-b ?piece-c ?piece-d)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (is-in ?box ?room)
        (final-box ?box)
        (putted-four-piece ?box)
        (not (= ?piece-a ?piece-d))
        (used ?piece-a)
        (used ?piece-b)
        (used ?piece-c)
        (used ?piece-d)
        (form3 ?piece-a)
        (form1 ?piece-b)
        (form4 ?piece-c)
        (form3 ?piece-d))
    :effect(and
        (not (putted-four-piece ?box))
        (putted-zero-piece ?box)
        (not (used ?piece-a))
        (not (used ?piece-b))
        (not (used ?piece-c))
        (not (used ?piece-d))
        (out ?piece-a)
        (out ?piece-b)
        (out ?piece-c)
        (out ?piece-d)
        )
    )
    (:action complete_a_level7
    :parameters (?shakey ?room ?box ?piece-a ?piece-b ?piece-c ?piece-d)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (is-in ?box ?room)
        (final-box ?box)
        (putted-four-piece ?box)
        (used ?piece-a)
        (used ?piece-b)
        (used ?piece-c)
        (used ?piece-d)
        (not (= ?piece-a ?piece-b))
        (form5 ?piece-a)
        (form5 ?piece-b)
        (form4 ?piece-c)
        (form3 ?piece-d))
    :effect(and
        (not (putted-four-piece ?box))
        (putted-zero-piece ?box)
        (not (used ?piece-a))
        (not (used ?piece-b))
        (not (used ?piece-c))
        (not (used ?piece-d))
        (out ?piece-a)
        (out ?piece-b)
        (out ?piece-c)
        (out ?piece-d)
        )
    )
    (:action complete_a_level8
    :parameters (?shakey ?room ?box ?piece-a ?piece-b ?piece-c ?piece-d)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (is-in ?box ?room)
        (final-box ?box)
        (putted-four-piece ?box)
        (not (= ?piece-b ?piece-c))
        (used ?piece-a)
        (used ?piece-b)
        (used ?piece-c)
        (used ?piece-d)
        (form1 ?piece-a)
        (form3 ?piece-b)
        (form3 ?piece-c)
        (form2 ?piece-d))
    :effect(and
        (not (putted-four-piece ?box))
        (putted-zero-piece ?box)
        (not (used ?piece-a))
        (not (used ?piece-b))
        (not (used ?piece-c))
        (not (used ?piece-d))
        (out ?piece-a)
        (out ?piece-b)
        (out ?piece-c)
        (out ?piece-d)
        )
    )
    (:action complete_a_level9
    :parameters (?shakey ?room ?box ?piece-a ?piece-b ?piece-c ?piece-d)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (is-in ?box ?room)
        (final-box ?box)
        (putted-four-piece ?box)
        (not (= ?piece-a ?piece-b))
        (not (= ?piece-d ?piece-c))
        (used ?piece-a)
        (used ?piece-b)
        (used ?piece-c)
        (used ?piece-d)
        (form1 ?piece-a)
        (form1 ?piece-b)
        (form3 ?piece-c)
        (form3 ?piece-d))
    :effect(and
        (not (putted-four-piece ?box))
        (putted-zero-piece ?box)
        (not (used ?piece-a))
        (not (used ?piece-b))
        (not (used ?piece-c))
        (not (used ?piece-d))
        (out ?piece-a)
        (out ?piece-b)
        (out ?piece-c)
        (out ?piece-d)
        )
    )
    (:action deposit_one_piece_last_level                         ;;nel caso in cui avanzi solo una forma la inseisco senza dover completare il livello
    :parameters (?shakey ?room ?box ?piece ?box1 ?box2 ?limited-container1 ?limited-container2)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (is-in ?box ?room)
        (final-box ?box)
        (used ?piece)
        (limited-container ?limited-container1)
        (limited-container ?limited-container2)
        (at v0 ?limited-container2)
        (at v0 ?limited-container1)
        (clear void ?box1)
        (clear void ?box2)
        (putted-one-piece ?box))
    :effect (and
        (not (used ?piece))
        (out ?piece)
        (not (putted-one-piece ?box))
        )
    )
    
    (:action deposit_two_piece_last_level                        ;;nel caso in cui avanzino due forme le inseisco senza dover completare il livello
    :parameters (?shakey ?room ?box ?piece-a ?piece-b ?box1 ?box2 ?limited-container1 ?limited-container2)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (is-in ?box ?room)
        (final-box ?box)
        (used ?piece-a)
        (used ?piece-b)
        (not (= ?piece-a ?piece-b))
        (limited-container ?limited-container1)
        (limited-container ?limited-container2)
        (at v0 ?limited-container2)
        (at v0 ?limited-container1)
        (box ?box1)
        (box ?box2)
        (putted-two-piece ?box)
        (clear void ?box1)
        (clear void ?box2))
    :effect (and
        (not (putted-two-piece ?box))
        (not (used ?piece-a))
        (not (used ?piece-b))
        (out ?piece-a)
        (out ?piece-b)
        )
    )
     
    ;;permette di far cambiare stanza a shakey, NB: può trasportare un pezzo quando cammina da una stanza all'altra perchè ha la mano libera
    (:action shakey_changes_room
    :parameters (?shakey ?room-a ?door-a ?room-b ?door-b ?corridor)
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
    
    
    ;;permette a shakey di spostare le scatole tra le stanze, NB: shakey si può muovere solo se ha la mano libera
    (:action shakey_pushes_box_between_rooms
    :parameters (?shakey ?box ?room-a ?door-a ?room-b ?door-b ?corridor ?hand)
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
        (empty ?hand)
        (hand ?shakey ?hand)
    )
    :effect (and
        (is-in ?shakey ?room-b)
        (not (is-in ?shakey ?room-a))
        (is-in ?box ?room-b)
        (not (is-in ?box ?room-a))
        (not (is-under-switch ?box ?room-a))
        )
    )
    
    ;;permette a shakey di salire sulle scatole
    (:action shakey_climbs_on_the_box
    :parameters (?shakey ?box ?room ?hand)
    :precondition (and
        (shakey ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (box ?box)
        (is-in ?box ?room)
        (is-on-floor ?shakey)
        (hand ?shakey ?hand)
        (empty ?hand)
    )
    :effect (and
        (is-on ?shakey ?box)
        (not (is-on-floor ?shakey))
        )
    )
    
    ;;permette a shakey di scenderre dalle scatole 
    (:action shakey_gets_out_the_box
    :parameters (?shakey ?box ?room ?hand)
    :precondition (and
        (shakey ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (box ?box)
        (is-in ?box ?room)
        (is-on ?shakey ?box)
        (hand ?shakey ?hand)
        (empty ?hand)
    )
    :effect (and
        (is-on-floor ?shakey)
        (not (is-on ?shakey ?box))
        )
    )
    
    ;;permette a shakey di accendere la luce
    (:action shakey_turns_on_the_light
    :parameters (?shakey ?box ?room ?switch ?hand)
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
        (hand ?shakey ?hand)
        (empty ?hand)
    )
    :effect (and
        (lit ?switch)
        (not (off ?switch))
        )
    )
    
    ;;permette a shakey di spegnere la luce
    (:action shakey_turns_off_the_light
    :parameters (?shakey ?box ?room ?switch ?hand)
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
        (hand ?shakey ?hand)
        (empty ?hand)
    )
    :effect (and
        (off ?switch)
        (not (lit ?switch))
        )
    )
    
    ;;permette a shakey di spostare le scatole sotto agli interruttori
    (:action shakey_pushes_box_under_switch
    :parameters (?shakey ?box ?room ?hand)
    :precondition (and
        (shakey ?shakey)
        (is-on-floor ?shakey)
        (is-in ?shakey ?room)
        (room ?room)
        (box ?box)
        (is-in ?box ?room)
        (hand ?shakey ?hand)
        (empty ?hand)
    )
    :effect 
        (is-under-switch ?box ?room)
    )
)