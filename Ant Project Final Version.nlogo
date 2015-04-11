;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;VARIABLES AND BREEDS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Variable not linked to any agent, can be accessed by any agent or the observer
globals[
  foodavail                  ;; The amount of food currently availible in the world
  printed?                   ;; Used to make the line about the death of the colony to print only once
  fprinted?                  ;; Used to make the line about the death of the Foreigner colony print only once
  foragers_working           ;; The agentset of Foragers that are currently foraging
  patrollers_working         ;; The agentset of Patrollers that are currently patrolling
  middenworkers_working      ;; The agentset of MiddenWorkers that are currently doing midden work
  numnestwork                ;; The total number of NestWorkers (Untasked Ants)
  numForage                  ;; The total number of Foragers
  numMiddenWork              ;; The total number of MiddenWorkers
  numPatrol                  ;; The total number of Patrollers
  numForeign                 ;; The total number of Foreigners
  colonysize                 ;; The total size of the colony
  antsinnest                 ;; The number of ants currently in the nest
  foodstore                  ;; The amount of food the nest has in storage
  foreignstore               ;; The amount of food the Foreigner nest has in storage
  piledmidden                ;; Amount of midden in the midden pile
  unsortedmidden             ;; Amount of unsorted midden
  phouse                     ;; One coordinate for the Predators home
  moonx                      ;; x coordinate of the moon
  moony                      ;; y coordinate of the moon
  foodx                      ;; X coordinate for the morning food pile
  foody                      ;; y coordinate for the morning food pile
  newx                       ;; x coordinate for midden
  newy                       ;; y coordinate for midden
  distx                      ;; x coordinate for middenpile
  disty                      ;; y coordinate for middenpile
  anteaterattack?            ;; True if there will be an AntEater attack that day
  attackduration             ;; How long the AntEater will attack the nest
  attacktime                 ;; When the attack will take place
  day                        ;; Starting at 1 counts the number of days since the model began
  time                       ;; Controls the time of day, resets at night
  timeofday                  ;; Equals either "Morning", "Day", "Evening", or "Night" depending on time
]

;; Breeds in this model represent what task each member of the colony is currently
;; assigned and turtle of other types
breed [MiddenWorkers middenWorker] 
breed [Patrollers patroller]
breed [Foragers forager]
breed [foreigners foreigner]
breed [nestworkers nestworker]
breed [AntEaters anteater]
breed [Predators predator]

;; Links in the model are used as the ants memory to keep track of their
;; encounters with ants of each task
directed-link-breed[ MWlinks mwlink]
directed-link-breed[ MWMlinks mwmlink]
directed-link-breed[ Plinks plink]
directed-link-breed[ PRlinks prlink]
directed-link-breed[ Flinks flink]
directed-link-breed[ FwFlinks fwflink]
directed-link-breed[ Slinks slink]

;; Variables assigned to each link
links-own [
  linkvalue                 ;; A counter used to determine how recently this link was formed, reduces on each tick
]
;; Variables assigned to each patch
patches-own [          
  star?                     ;; True if there is a star on this patch at night
  moon?                     ;; True if this patch is currently part of the moon
  fsource?                  ;; True if a Patroller has found food on this patch
  forsource?                ;; True if a Foreigner has found food on this patch
  fsource-scent             ;; A value that increases with proximity to a patch a Patroller food found on 
  forsource-scent           ;; A value that increases with proximity to a patch a Foreigner found food on
  psource?                  ;; True if this patch was along the trail of a Patroller returning from a food source
  fortrail?                 ;; True if this patch was along the trail of a Foreigner returning with food
  ppheromone                ;; The amount of ppheromone on this patch (left by Patrollers and Foragers)
  forpheromone              ;; The amount of forpheromone on this patch (left by Foreigners)
  forhere                   ;; The amount of forhere (pheromone dropped when foreigners are detected)
  fpheromone                ;; The amount of fpheromone on this patch (left by Foragers)
  food                      ;; The amount of food on this patch (0, 1, 2, or 3)
  nest?                     ;; True if this patch is part of the nest
  nestcenter?               ;; True if this patch is the center of the nest
  nest-scent                ;; A value that increase with proximity to the nest
  home?                     ;; True if this patch is part of the Foreigner's nest
  homecenter?               ;; True if this patch is the center of the Foreigner's nest
  home-scent                ;; A value that increases with Proximity to the Foreigner's nest
  midden                    ;; The amount of midden on this patch, can be any number
  middenpile?               ;; True on the patches that host that day's middenpile
  middenpile-scent          ;; A value that increases with proximity to that days midden pile
]
;; Variables assigned to each turtle
turtles-own [
  randomhundred             ;; A randomly generated number between zero and one hundred
  working?                  ;; True when a turtle is currently performing its task
  lifecount                 ;; A counter tracking the number of days each turtle has been alive
  middenlinks               ;; The number of MiddenWorkers encountered not currently carrying midden
  mwithmidden               ;; The number of MiddenWorkers encountered currently carrying midden
  foragerlinks              ;; The number of Foragers encountered not currently carrying food
  foragerswithfood          ;; The number of Foragers encountered currently carrying food
  patrollerlinks            ;; The number of Patrollers encountered that have not located a food source
  patrollersreturning       ;; The number of Patrollers encountered that have located a food source
  foreignerlinks            ;; The number of Foreigners encountered
]
;; Variables assigned to Foragers
foragers-own[
  carryingfood?             ;; True when the Foragers is currently carrying food
]
;; Variables assigned to MiddenWorkers
middenworkers-own[
  carryingmidden?           ;; True when the MiddenWorker is currently carrying midden
  middenfound               ;; Decreases with time since the ant last found a piece of midden
]
;; Variables assigned to Patrollers
patrollers-own[
  linktime                  ;; A counter that makes the patroller wait before disappearing so several ants can form links
  encountertime             ;; A counter used to track the time since meeting a Foreigner
  patrolledtoday?           ;; True if the Patroller has already found a food source that day and returned to the nest
  foodfound?                ;; True if the Patroller has found a food source
  metforeigner?             ;; True if the Patroller has encountered a Foreigner that day
  follower?                 ;; True if the Patroller is looking for food in the previous day's locations
]
;; Variables assigned to Foreigners
foreigners-own[
  alive?                    ;; True if the Foreigner has found food that day and thus will live to the next day
  carryingfood?             ;; True if the Foreigner is currently carrying food
]
;; Variables assigned to Predators
predators-own[
  eaten?                    ;; True if the Predator has eaten an ant that day
]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;SETUP FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Setup - This function set the model to its inital state when "Setup" is clicked in the interface. 
to setup
  clear-all
  set printed? false
  set fprinted? false
  set anteaterattack? true
  set day 1
  set phouse (75 + (random-pxcor / 2))
  set timeofday "morning"
  set foodx random-pxcor
  set foody random-pycor
  set newx  (random-pxcor / 3) + 4
  set newy  (random-pycor / 3) + 4
  set distx random-pxcor + 4
  set disty random-pycor + 4
  set-default-shape MiddenWorkers "ant" 
  set-default-shape Foragers "ant" 
  set-default-shape Patrollers "ant"
  set-default-shape nestworkers "ant"
  set-default-shape Foreigners "ant"
  set-default-shape Predators "ant 2" 
  set-default-shape AntEaters "anteater"
  create-AntEaters 1
  [ set color grey
    set size 30
    setxy random-pxcor max-pycor]
  create-MiddenWorkers numberMidden
  [ set color black
    set size 2
    setxy (min-pxcor + 10) (min-pycor + 10)
    set carryingmidden? false
    set middenfound 0]
  create-Foragers numberForage
  [ set color green - 1 
    set size 2
    setxy (min-pxcor + 10) (min-pycor + 10)
    set carryingfood? false]
  create-Patrollers numberPatrol
  [ set color yellow - 1
    set size 2
    setrh
    set linktime 0
    set foodfound? false
    set patrolledtoday? false
    set metforeigner? false
    setxy (min-pxcor + 10) (min-pycor + 10)] 
  create-Foreigners numberForeign
  [ set color magenta + 2
    set size 2
    set alive? false
    set carryingfood? false
    setxy max-pxcor max-pycor]
  create-predators dangerlevel
  [ set color red - 1
    set size 3
    set eaten? false
    setxy (75 + (random-xcor / 2)) max-pycor]
  ask turtles [
    set working? false
    setrh
    hide-turtle]
  ask patrollers
  [ ifelse randomhundred > 20
    [ set follower? true]
    [ set follower? false]]
  set numpatrol count patrollers
  set numforage count foragers
  set nummiddenwork count middenworkers
  set numnestwork count nestworkers
  set numforeign count foreigners
  set colonysize (numforage + nummiddenwork + numpatrol + numnestwork)
  set foodstore 1.5 * colonysize 
  set foreignstore 1.5 * numforeign
  Chance-of-attack
  setup-stars
  setup-moon
  setup-patches
  set foodx (random-pxcor / 1.5) + 4
  set foody (random-pxcor / 1.5) + 4
  ask patches 
  [ setup-food 
    recolor-patch]
  set foodavail sum [ food ] of patches
  reset-ticks
end
;; Sets up the chance of an AntEater attacking that day
to Chance-of-Attack
  ifelse Anteater_Attacks = "on" 
  [ let x random 100
    if x < 25
    [ set anteaterattack? true
      set attacktime one-of ["morning" "day" "evening"]
      set attackduration 100 + random 300]]
  [ set anteaterattack? false]
end
;; Sets up the patches with food based on the FamineLevel. Called by Setup-Patches.
to setup-food
  if (distancexy foodx foody) < 2 + random (300 / FamineLevel)
    [ set food one-of [1 2 3]]
end
;; Sets up the patches with the nest on them. Called by Setup-Patches.
to setup-nest            
  set nest? (distancexy (min-pxcor + 10) (min-pycor + 10)) < 6 
  set nestcenter? (distancexy (min-pxcor + 10) (min-pycor + 10)) < 1.5
  set nest-scent 50000 - (distancexy (min-pxcor + 10) (min-pycor + 10)) ^ 2
end
;; Sets up the patches with the Foreigners nest on them. Called by Setup-Patches
to setup-home
  set home? (distancexy max-pxcor max-pycor) < 10
  set homecenter? (distancexy max-pxcor max-pycor) < 3.5
  set home-scent 200 - (distancexy max-pxcor max-pycor)
end
;; Sets up the patches for that day's middenpile. Called by Setup-Patches.
to setup-middenpile
  set middenpile? (distancexy newx newy) < 7
  set middenpile-scent 200 - (distancexy newx newy) ^ 2
end
;; Distributes midden to the patches surrounding the nest that do not already have midden on them.
;; Called by Setup-Patches.
to setup-midden
  if midden = 0
  [ ifelse distancexy random-pxcor random-pycor < 20
    [ set midden 1 ]  
    [ set midden 0 ]]
end
;; Sets the location of the moon over the course of the night. Used for the NightAnimation. Called by Go.
to setup-moon
  set moonx max-pxcor * (time - daylength - 10) / 5
  set moony (-1 / 100) * ((moonx - 75) ^ 2) + 75
  ask patches[
    set moon? (distancexy moonx moony) < 5]
end
;; Sets the location of the stars. Used for the NightAnimation. Called by Setup 
;; NOTE: It also sets fsource? and forsource? false for every patch, because setup-stars is called by
;; Setup not Setup-Patches this only happens on each setup, not each new day
to setup-stars
  ask patches [
    set fsource? false
    set forsource? false
    set star? (distancexy random-pxcor random-pycor) < 4]
end
;; Organizes all the functions for setting up patches into one function. Called by Setup and NewDay.
to  setup-patches
  ask patches[ 
    set ppheromone 0
    set fpheromone 0
    set forpheromone 0
    set psource? false
    set fortrail? false
    setup-food
    setup-midden
    setup-middenpile  
    setup-nest
    setup-home
    recolor-patch]
end    
;; Assigns the correct color to each patch based on the patches variables. Called by Setup-Patches and Go.
to recolor-patch  
  if timeofday = "morning" [
    set pcolor sky ] 
  if timeofday = "day" [
    set pcolor sky - 1 ]
  if timeofday = "evening" [ 
    set pcolor sky - 3 ]
  ifelse fsource? [set pcolor lime - 1 + food]
  [ ifelse fpheromone > 3.3[ set pcolor scale-color green fpheromone 15 1]
    [ ifelse food > 0 [set pcolor green - 3 + food]
      [ ifelse nest? [set pcolor brown - 5 + (distancexy (min-pxcor + 10) (min-pycor + 10))]
        [ ifelse forhere > 1 [set pcolor scale-color red forhere 15 0.01] 
          [ ifelse forpheromone > 0.05 [set pcolor scale-color magenta forpheromone 15 0.05]
            [ ifelse ppheromone > 7 [set pcolor scale-color yellow ppheromone 3000 7]
              [ ifelse midden > 7 [set pcolor orange + 4]
                [ ifelse midden > 0 [set pcolor orange - 4 + midden]
                  [ if home? [set pcolor orange - 5 + (.5 * (distancexy max-pxcor max-pycor))]]]]]]]]]]
  if timeofday = "night" 
    [ ifelse moon? [set pcolor white]
      [ ifelse star?
        [ set pcolor yellow]
        [ set pcolor black]]]
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GO FUNCTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; This function runs on every "tick" and moves the model world foward by one. How quickly this happens depends on the
;; CPU performance of the computer running NetLogo and the "Speed" setting in the interface. On capable hardware
;; "Normal Speed" should run the model at 30 tick per second
;; NOTE: As the size of the colony or the area grows so does the amount of computation required
;; most computers will not run the simulation at full speed with more than 250 ants in the simulation
to go
  ;; Sets the values for the monitors in the Interface
  if any? foragers [set foragers_working (count foragers with [working?] / count foragers)]
  if any? patrollers [set patrollers_working (count patrollers with [working?] / count patrollers)]
  if any? middenworkers [set middenworkers_working (count middenworkers with [working?] / count middenworkers)]
  set unsortedmidden count patches with [midden > 0 and not middenpile?] 
  set foodavail sum [ food ] of patches
  set numpatrol count patrollers
  set numforage count foragers
  set nummiddenwork count middenworkers
  set numnestwork count nestworkers
  set colonysize (numforage + nummiddenwork + numpatrol + numnestwork)
  set numforeign count foreigners
  set time (ticks / 30) 
  
  ;; Setts the different values for timeofday based on the value of time
  ifelse time < 5 
  [ set timeofday "morning"]
  [ ifelse time < 5 + daylength
    [ set timeofday "day"]
    [ ifelse time < 10 + daylength
      [ set timeofday "evening"]
      [ ifelse Night_Animation = "on"
        [ set timeofday "night"
          setup-moon
          if (time > 15 + daylength)
          [newday]]
        [ if time > 10 + daylength
          [ set timeofday "night"
            newday]]]]]
  
  ;; Sets the rate at which the colony's foodsupply is deplated and what happens if it reaches zero
  ifelse foodstore > 0 
  [ if not (timeofday = "night")
    [ set foodstore foodstore - consumption * (antsinnest / 1000)]]
  [ ifelse one-of turtles with [nest?] = nobody
    [ if not printed? 
      [ show "The colony has died"
        set printed? true]]
    [ ask one-of turtles with [nest?] [die]
      show " An ant has been eaten"
      set foodstore foodstore + 5]]
  
  ;; Sets the rate at which the Foreigner's foodsupply is deplated and what happens if it reaches zero
  ifelse foreignstore > 0 
  [ if not (timeofday = "night")
    [ set foreignstore foreignstore - consumption * ((count Foreigners with [not alive?]) / 1000)]]
  [ ifelse (one-of Foreigners) = nobody
    [ if not fprinted? 
      [ show "The neighboring colony has died"
        set fprinted? true ]]
    [ ask one-of Foreigners [die]
      show " An neighboring ant has been eaten"
      set foreignstore foreignstore + 3 ]]
  
  ;; Patch Related - Handles the diffusion and evaporation rates of the various pheromones and scents
  diffuse fpheromone  .15
  diffuse ppheromone  .05
  diffuse forpheromone .15
  diffuse forhere .15
  diffuse fsource-scent .92
  diffuse forsource-scent .75
  ask patches
  [ set fpheromone fpheromone * .95  
    set ppheromone ppheromone * .901
    set forpheromone forpheromone * .90 
    set forhere forhere * .98 
    set fsource-scent fsource-scent * 0.5 
    set forsource-scent forsource-scent * 0.8  
    if psource?  
      [ if fpheromone > 0 [set fpheromone fpheromone * 1.05]
        set ppheromone ppheromone * 1.119]
    if fortrail? [ set forpheromone forpheromone * 1.05]
    if fsource?  
    [ set ppheromone ppheromone  + (55 / (time + 0.01 / 3))
      set fsource-scent 400]
    if forsource? 
    [ set forpheromone forpheromone + (35 / time)
     set forsource-scent forsource-scent + 25]
    if (distancexy (min-pxcor + 10) (min-pycor + 10)) = 0
      [ set antsinnest (count turtles in-radius 3)]
    if not any? neighbors4 with [food > 0]
    [ set forsource? false ]
    recolor-patch]
  
  ;; Decrease the linkvalue of each link by one, if the link value reaches zero the link dies
  ask links   
  [ set linkvalue linkvalue - 1
    if linkvalue = 0 
    [ die ]]
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;TURTLE BEHAVIORS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  ;; Controls the behavior of Patrollers
  ask Patrollers [
    set linktime linktime - 1
    if foreignerlinks > 250 or forsource-scent > 0.05
      [ set metforeigner? true ]
    if timeofday = "day" or timeofday = "morning"
    [ show-turtle
      UpdateLinks
      if ticks > randomhundred 
      [ifelse metforeigner?
        [ area-clean ]
        [ set working? true
          ifelse foodfound?
          [ ifelse patrolledtoday? 
            [ ifelse linktime > 0
              [ rt random 45
                lt random 45
                move
                uphill-nest-scent ]
              [ ifelse nestcenter?
              [ hide-turtle
                set working? false
                rt random 50
                lt random 50
                move]
              [ hide-turtle
                set working? false
                ifelse (distancexy 0 0) < 17 or xcor < 7 or ycor < 7
                [ uphill-middenpile-scent ]
                [ ifelse nest-scent < 49600 
                  [return-to-nest ]
                  [ lt random 50
                    rt random 50 ]]
                move]]]
            [ finishpatrol
              move ]]
          [ patrol
            rt random 30 
            lt random 30
            move ]]]]
    if timeofday = "day" 
    [taskswitch]  
    if timeofday = "evening" 
      [ifelse nestcenter?
        [stop]
        [if not nest? [return-to-nest]
          move]]]
  
  ;; Controls the behavior of Foragers
  ask Foragers [
    if timeofday = "day" or timeofday = "morning"
    [ show-turtle
      UpdateLinks
      ifelse (patrollersreturning + foragerswithfood > 300)
        [ ifelse foreignerlinks > 250
          [ uphill-nest-scent
            move ]
          [ set working? true
            ifelse carryingfood?
            [ return-with-food ]       
            [ look-for-food ]
            move ]]          
        [ set working? false
          ifelse nestcenter?
          [ set working? false
            stop]
          [ ifelse carryingfood?
            [ return-with-food ]
            [ return-to-nest ]
          move ]]]      
    if timeofday = "evening" 
      [ ifelse nestcenter?
        [ stop ]
        [ ifelse carryingfood?
          [ return-with-food ]
          [ return-to-nest ]
        move ]]]
  
  ;; Controls the behavior of MiddenWorkers
  ask MiddenWorkers [
    set middenfound middenfound - 1
    if timeofday = "day" or timeofday = "morning"
    [ show-turtle
      UpdateLinks
      ifelse (patrollersreturning + mwithmidden + middenfound > 10) or carryingmidden?
        [ ifelse foreignerlinks > 250
          [ uphill-middenpile-scent
            move ]
          [ set working? true
            ifelse carryingmidden?
            [ pilemidden ]
            [ if not middenpile?
              [ gathermidden ]]  
            move ]]
        [ set working? false
          ifelse nestcenter?
          [ stop ]
          [ return-to-nest
            move ]]]
    if timeofday = "day" 
    [ taskswitch ]  
    if timeofday = "evening" 
      [ ifelse nestcenter?
        [ stop ]
        [ return-to-nest
          move ]]]
  
  ;; Controls the behavior of NestWorkers (Untasked ants that are "born" each day)
  ask Nestworkers [ 
    UpdateLinks
    taskswitch 
    ifelse (distancexy 0 0) < 17 or xcor < 7 or ycor < 7
      [ uphill-home-scent ]
      [ ifelse nest-scent < 49600 
        [return-to-nest ]
        [ lt random 50
          rt random 50 ]]
      move]
  
  ;; Controls the behavior of Foreigners (ants from a different colony)
  ask Foreigners [
    if timeofday = "day" or timeofday = "morning"
    [ Updatelinks
      show-turtle
        ifelse carryingfood?
        [ Bring-Home ]
        [ Foreign-Gather ]
        move ]
    if timeofday = "evening"     
    [ ifelse homecenter?
      [ hide-turtle
        stop]
      [ Return-Home 
        move ]]]
  
  ;;Controls the behavior of Predators (ants from a different species that eat this species)
  ask Predators [
    Show-Turtle
    if timeofday = "day" or timeofday = "morning"
    [ setrh
      if randomhundred > 50 [predator-eat-ant]
      rt random 45
      lt random 45
      if (middenpile-scent / 2) + (middenpile-scent * (piledmidden / 25)) > 125
      [ facexy max-pxcor max-pycor
        rt random 15
        lt random 15]
      move]
    if timeofday = "evening" 
    [ facexy phouse max-pycor
      fd 1
      if pycor = max-pycor
      [hide-turtle
        stop]]]
  
  ;; Controls the behavior of AntEaters
  ask AntEaters [
    if anteaterattack?
    [ifelse attackduration > 0 and attacktime = timeofday
      [show-turtle
        ifelse nest? 
        [ AntEater-eat-ant
          set attackduration attackduration - 1]
        [ uphill-nest-scent
          move]]
      [ facexy 75 max-pycor
        move
        if pycor = max-pycor
        [ hide-turtle
          set anteaterattack? false]]]]
  
  ;; Hides all of the turtles at night and when they are in the nest
  ask turtles [  
    if timeofday = "night" or nestcenter? or homecenter?
    [hide-turtle]]
  
  ;; Moves the tick value forward by one
  tick 
end 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;NEW DAY FUNCTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to newday
  ;; World Reset
  set printed? false
  set fprinted? false
  set piledmidden 0
  set foodx (random-pxcor / 1.5) + 4
  set foody (random-pxcor / 1.5) + 4
  set newx  (random-pxcor / 3) + 4
  set newy  (random-pycor / 3) + 4
  set distx random-pxcor + 4
  set disty random-pycor + 4
  
  ;; Creates new ants for the colony based on several variables
  if foodstore > colonysize [  
    create-nestworkers (colonysize * birthrate) / 100
    [ set color white
      set size 2
      setxy (min-pxcor + 10) (min-pycor + 10) ]]
  
  ;; Removes the links from the previous day
  clear-links
  
  ;; Reset variables specific to certain breeds and set there position to the center of the nest
  ask foragers 
  [ set carryingfood? false 
    setxy (min-pxcor + 10) (min-pycor + 10)]
  ask patrollers 
  [ setxy (min-pxcor + 10) (min-pycor + 10)
    set linktime 0
    set patrolledtoday? false
    set foodfound? false
    set metforeigner? false
    ifelse randomhundred > 20 
    [ set follower? true ]
    [ set follower? false ]]
  ask middenworkers
  [ set middenfound 0
    set carryingmidden? false
    setxy (min-pxcor + 10) (min-pycor + 10) ]
  
  ;; Resets variables common to all turtles, sets their location to the nest, and increases their life count 
  Ask turtles [ 
    setrh
    set working? false
    updatelinks
    set lifecount lifecount + 1
    if lifecount > (random lifespan)
    [die]]
  
  ;; Creates more Foreigners based on how many found food the previous day
  create-Foreigners (count Foreigners with [ alive? ] / 3)
  [ set color magenta + 1
    set size 2
    set alive? false
    set carryingfood? false
    setxy max-pxcor max-pycor ]  
  
  ;; Kills off Foreigners that were unable to find food
  ask foreigners
  [ if not alive?
    [ setrh
      if randomhundred < 50
      [die]]
  set alive? false
  setxy max-pxcor max-pycor ]
  
  ;; If all or most of the Foreigners died the previous day this creates new ones
  if numforeign < (numberforeign / 2)
  [ create-Foreigners (numberforeign / 3)
    [ set color magenta + 1
      set size 2
      set alive? false
      set carryingfood? false
      setxy max-pxcor max-pycor ]] 
  
  ;; This adds food to the Foreigner food supply if the previous Foreigners starve so the new
  ;; ants do not immediately meet the same fate
  if Foreignstore <= 0
  [ set foreignstore (1.5 * count foreigners) ]
  
  ;; Resets the number of Predators for the new day's DangerLevel
  if not (count Predators = dangerlevel)
  [ ask Predators [die] 
    create-Predators DangerLevel
    [ set color red
      set size 3 
      setxy ( 75 + (random-pxcor / 2)) max-pycor]]
  
  ;; Removes the unsorted midden from the previous day to make room for the new midden every nine
  ;; days it removes the midden accumulating from the midden pile
  ask patches
  [ ifelse (remainder day 9) = 0
    [set midden 0]
    [if not middenpile? [set midden 0]]]
    
  ;; Increases the daycount, sets up the patches, the chance of an anteater attacking
  Chance-of-attack
  set day day + 1
  setup-patches
  
  ;; Creates an extra pile of food some days, more likely when the famine level is low
  if FamineLevel < (random 200) 
  [ set foodx random-pxcor 
    set foody random-pxcor 
    ask patches
    [setup-food
      recolor-patch]]
  
  ;; Resets the tick which serves as the day clock
  reset-ticks
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;TASK SWITCHING FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Keeps tracks of the links formed by each ant
to UpdateLinks 
  middenlink
  foragelink
  patrollink
  foreignlink
  ifelse count flinks > 0
  [ set foragerlinks sum [linkvalue] of my-out-flinks ]
  [ set foragerlinks 0 ]
  ifelse count fwflinks > 0
  [ set foragerswithfood sum [linkvalue] of my-out-fwflinks ]
  [ set foragerswithfood 0 ]
  ifelse count mwlinks > 0
  [ set middenlinks sum [linkvalue] of my-out-mwlinks ]
  [ set middenlinks 0 ] 
  ifelse count mwmlinks > 0
  [ set mwithmidden sum [linkvalue] of my-out-mwmlinks ]
  [ set mwithmidden 0 ]
  ifelse count plinks > 0
  [ set patrollerlinks sum [linkvalue] of my-out-plinks ]
  [ set patrollerlinks 0 ]
  ifelse count prlinks > 0
  [ set patrollersreturning sum [linkvalue] of my-out-prlinks ]
  [ set patrollersreturning 0 ]
  ifelse count slinks > 0
  [ set foreignerlinks sum [linkvalue] of my-out-slinks ]
  [ set foreignerlinks 0 ]
end

;; Determines the thresholds for switch to each of the tasks
to taskSwitch 
  ifelse 28 * mwithmidden > middenlinks and (randomhundred > 50 or is-nestworker? self)
  [ middenswitch ]
  [ ifelse 6 * patrollersreturning  > patrollerlinks and (randomhundred > 50 or is-nestworker? self)
    [ patrolswitch ]
    [ if 15 * foragerswithfood > foragerlinks and (randomhundred > 50 or is-nestworker? self)
      [ forageswitch ]]]                          
end

;; These three functions handle switching any turtle to their respective task
to forageswitch                   
  hatch-Foragers 1[ 
    set color green - 1
    set patrollersreturning 0
    set foragerswithfood 0  
    set carryingfood? false]
  die      
end
to middenswitch  
  hatch-middenWorkers 1 [
    set color black
    set patrollersreturning 0
    set foragerswithfood 0 
    set carryingmidden? false
    set middenfound 0]
  die
end
to patrolswitch  
  hatch-patrollers 1 [
    set color yellow - 1   
    set linktime 0
    set patrollersreturning 0
    set foragerswithfood 0 
    set foodfound? false
    set patrolledtoday? false
    set metforeigner? false
    setrh
    ifelse randomhundred > 50
    [set follower? true]
    [set follower? false]]
  die
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;BREED SPECIFIC FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Patroller Behavior - Makes the ant wander around until it find food,
;; depending on the ant it might seek out previous food locations 
to patrol
  if forsource-scent > 0.01
    [ downhill-forsource-scent ]
  if forhere > 0.01
  [ downhill-forhere ]
  if food > 0 
    [ set foodfound? true
      set ppheromone (ppheromone + (food * 75))
      set fsource? true]
  if fsource? and not (food > 0) [set fsource? false]
  if (any? patches with [fsource?]) and follower? 
  [uphill-fsource-scent]
  rt random 25
  lt random 25
end

;; Patroller Behavior - Makes the ant return to the nest when it finds food 
;; It leaves ppheromone along the way
to finishpatrol
  if foodfound? and forhere < 0.5
    [ set ppheromone ppheromone + (50500 - nest-scent) + ((50500 - nest-scent) ^ 3) / 10000000
      set psource? true
      rt random 25
      lt random 25
      uphill-nest-scent ]
  if nest? 
    [ set patrolledtoday? true 
      set linktime 15 ]
end

;; Patroller Behavior - Makes the ant clean all markings of their colony from a food source if it encounters another ant or their arkings
to area-clean
  ask neighbors [ set ppheromone 1 ]
  ask neighbors [ set fpheromone 0 ]
  ask neighbors [ set psource? false ]
  ask neighbors [ set fsource? false ]
  ask neighbors [ set forsource? false ]
  ask neighbors [ set forhere forhere + 25 ]  
  ifelse encountertime < 20
  [ ifelse fsource-scent > 0.000000000001 
    [ uphill-fsource-scent 
      fd 1 ]
    [ if ppheromone > 0.001
      [ uphill-ppheromone ]
    fd 1 ]]
  [ ifelse encountertime < 125
    [ ifelse (encountertime = 20 or encountertime = 55 or encountertime = 90)
      [ lt 200
        fd 1 ]
      [ rt 10
        fd 1 ]]
    [ ifelse encountertime < 130
      [ move ]
      [ ifelse encountertime < 150
        [ rt 6
          fd 1 ]
        [ set metForeigner? false
          set encountertime 0 
          downhill-forsource-scent
          fd 5 ]]]]
  set encountertime encountertime + 1
end

;; Forager Behavior - Makes the ant follow the strongest smell of ppheromone,
;; or fpheromone in the absence of the former, in search of food
to look-for-food  
  if food > 0
  [ set carryingfood? true     
    set food food - 1          
    set fsource? false
    rt 180                     
    stop ]                     
  ifelse nest?
  [ if ppheromone > 0.00001 [ face max-one-of patches [ ppheromone ]]]
  [ ifelse ppheromone < 0.0001
    [ ifelse nest-scent < 49000 [ uphill-nest-scent ]
      [ rt random 45
        lt random 45 ]]
    [ uphill-ppheromone 
      if forhere > 0.05
      [ downhill-forhere ]]]
  set psource? false
end

;; Foragers Behavior - Makes the ant return to the nest when it finds food
;; It strengthens the ppheromone and drops fpheromone along the way
to return-with-food 
  ifelse nest?
  [ set foodstore foodstore + 1
    set carryingfood? false
    set working? false
    rt 180 ]
  [ rt random 25
    lt random 25
    uphill-nest-scent
    set fpheromone fpheromone + 30
    set ppheromone ppheromone + (50100 - nest-scent) + ((50100 - nest-scent) ^ 3) / 10000000 ]         
end 

;; MiddenWorker Behavior - Makes the ant wander around looking for midden within
;; a certain radius of the nest
to gathermidden  
  if midden > 0
    [ set carryingmidden? true 
      set midden midden - 1 
      set middenfound 90
      stop ]
  ifelse [ midden > 0 ] of one-of neighbors 
  [ face one-of neighbors with [ midden > 0 ]
    fd 1] 
  [ lt random 45
    rt random 45 ]               
end

;; MiddenWorker Behavior - Makes the ant bring midden it has found to the middenpile
;; Piles the midden, each patch can only hold one more midden than the average of the surrounding patches
to pilemidden 
  ifelse middenpile? 
    [ if ([ midden ] of patch-here <= mean [ midden ] of neighbors4)
      [ set carryingmidden? false
        set piledmidden piledmidden + 1
        set midden midden + 1
        rt 180 ]]
    [ uphill-middenpile-scent ]
end   

;; Foreigner Behavior - Equivalent to look-for-food
to Foreign-Gather
  if food > 0
  [ set carryingfood? true
    set food food - 1
    set forsource? true
    set forsource-scent forsource-scent + 100
    rt 180
    stop ]
  lt random 50
  rt random 50
  if home? [facexy (random-pxcor / 2) (random-pycor / 2)
    fd 1 ]  
  if forsource? and food = 0 [ set forsource? false ]
  if forsource-scent > 0.05 [ uphill-forsource-scent ]
  if ((home-scent < ( 200 - MinimumForeignerRange ) and 
       home-scent < ( 200 - MinimumForeignerRange ) * (foreignstore / numforeign) ) or
       middenpile-scent > 100)
  [ facexy max-pxcor max-pycor ]
end

;;Foreigner Behavior - Equivalent to return-with-food
to Bring-Home
  ifelse homecenter?
  [ set carryingfood? false
    set foreignstore foreignstore + 1
    set alive? true]
  [ set forpheromone forpheromone + 25
    set fortrail? true
    uphill-home-scent]
end

;;Foreigner Behavior - Equivalent to return-to-nest
to Return-Home
  uphill-home-scent
end 

;; Predator Behavior - Makes the different species of ant "eat" any of the harvester ants
to Predator-Eat-Ant 
  let Pprey one-of Patrollers-on neighbors4
  if Pprey != nobody
  [ask Pprey [die]]
  let Fprey one-of Foragers-on neighbors4
  if Fprey != nobody
  [ask Fprey [die]]
  let MWprey one-of MiddenWorkers-on neighbors4
  if MWprey != nobody
  [ask MWprey [die]]
  let Nprey one-of NestWorkers-on neighbors4
  if Nprey != nobody
  [ask Nprey [die]]
  let Sprey one-of Foreigners-on neighbors4
  if Sprey != nobody
  [ask Sprey [die]]
end 

;; AntEater Behavior - Close to Predator-Eat-Ant but eats ants in a larger radius around the AntEater
to AntEater-Eat-Ant 
  let Pprey one-of Patrollers-on neighbors
  if Pprey != nobody
  [ask Pprey [die]]
  let Fprey one-of Foragers-on neighbors
  if Fprey != nobody
  [ask Fprey [die]]
  let MWprey one-of MiddenWorkers-on neighbors
  if MWprey != nobody
  [ask MWprey [die]]
  let Nprey one-of NestWorkers-on neighbors
  if Nprey != nobody
  [ask Nprey [die]]
  let Sprey one-of Foreigners-on neighbors
  if Sprey != nobody
  [ask Sprey [die]]
  let Predprey one-of Predators-on neighbors
  if Predprey != nobody
  [ask Predprey [die]]
end 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GENERIC TURTLE FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Return-to-Nest - Makes the turtle turn in the direction of the nest
to return-to-nest              
  uphill-nest-scent            
end

;; Move - Moves the turtle forward one and reverses the turtle's direction if it is stuck
to move 
  fd 1
  rt random 2
  lt random 2
  if not can-move? 1 [ rt 180 ]
end

;; SetRandomHundred (setrh) - Assigns a random number between zero and one hundred to the turtle variable
;; randomhundred. Usedful for assigning different values to a group of turtles
to setrh 
  set randomhundred random 100
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FUNCTIONS REPEATED FOR MULTIPLE USES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Turtle Procedures - The functions beginning with "uphill-" all work in the same manner. 
;; They check the value of the desired scent or pheromone on the patches to the right, left,
;; and directly ahead of the turtle. If the right or left value is higher the turtle turns in that direction
to uphill-fpheromone  
  let scent-ahead fpheromone-scent-at-angle   0
  let scent-right fpheromone-scent-at-angle  45
  let scent-left  fpheromone-scent-at-angle -45
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right < scent-left
    [ rt 45 ]
    [ lt 45 ] ]
end
to uphill-fsource-scent  
  let scent-ahead fsource-scent-at-angle   0
  let scent-right fsource-scent-at-angle  45
  let scent-left  fsource-scent-at-angle -45
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right > scent-left
    [ rt 45 ]
    [ lt 45 ] ]
  set scent-ahead fsource-scent-at-angle   0
  set scent-right fsource-scent-at-angle  25
  set scent-left  fsource-scent-at-angle -25
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right > scent-left
    [ rt 25 ]
    [ lt 25 ] ]
  set scent-ahead fsource-scent-at-angle   0
  set scent-right fsource-scent-at-angle  10
  set scent-left  fsource-scent-at-angle -10
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right > scent-left
    [ rt 10 ]
    [ lt 10 ] ]
end
to uphill-ppheromone  
  let scent-ahead ppheromone-scent-at-angle   0
  let scent-right ppheromone-scent-at-angle  45
  let scent-left  fpheromone-scent-at-angle -45
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right > scent-left
    [ rt 45 ]
    [ lt 45 ] ]
  set scent-ahead ppheromone-scent-at-angle   0
  set scent-right ppheromone-scent-at-angle  35
  set scent-left  fpheromone-scent-at-angle -35
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right < scent-left
    [ lt 35 ]
    [ rt 35 ] ]
  set scent-ahead ppheromone-scent-at-angle   0
  set scent-right ppheromone-scent-at-angle  25
  set scent-left  fpheromone-scent-at-angle -25
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right > scent-left
    [ rt 25 ]
    [ lt 25 ] ]
  set scent-ahead ppheromone-scent-at-angle   0
  set scent-right ppheromone-scent-at-angle  15
  set scent-left  fpheromone-scent-at-angle -15
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right < scent-left
    [ lt 15 ]
    [ rt 15 ] ]
end
to uphill-nest-scent  
  let scent-ahead nest-scent-at-angle   0
  let scent-right nest-scent-at-angle  50
  let scent-left  nest-scent-at-angle -50
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right > scent-left
    [ rt 50 ]
    [ lt 50 ] ]
  set scent-ahead nest-scent-at-angle   0
  set scent-right nest-scent-at-angle  25
  set scent-left  nest-scent-at-angle -25
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right > scent-left
    [ rt 25 ]
    [ lt 25 ] ]
end
to uphill-middenpile-scent  
  let scent-ahead middenpile-scent-at-angle   0
  let scent-right middenpile-scent-at-angle  45
  let scent-left  middenpile-scent-at-angle -45
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right > scent-left
    [ rt 45 ]
    [ lt 45 ] ]
end
to uphill-forsource-scent
  let scent-ahead forsource-scent-at-angle   0
  let scent-right forsource-scent-at-angle  45
  let scent-left  forsource-scent-at-angle -45
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right > scent-left
    [ rt 45 ]
    [ lt 45 ] ]
end
to uphill-home-scent  
  let scent-ahead home-scent-at-angle   0
  let scent-right home-scent-at-angle  45
  let scent-left  home-scent-at-angle -45
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right > scent-left
    [ rt 45 ]
    [ lt 45 ] ]
end
to downhill-forsource-scent
  let scent-ahead forsource-scent-at-angle   0
  let scent-right forsource-scent-at-angle  45
  let scent-left  forsource-scent-at-angle -45
  if (scent-right < scent-ahead) or (scent-left < scent-ahead)
  [ ifelse scent-right < scent-left
    [ rt 45 ]
    [ lt 45 ] ]
end
to downhill-forhere 
  let scent-ahead forhere-scent-at-angle   0
  let scent-right forhere-scent-at-angle  90
  let scent-left  forhere-scent-at-angle -90
  if (scent-right < scent-ahead) or (scent-left < scent-ahead)
  [ ifelse scent-right < scent-left
    [ rt 90 ]
    [ lt 90 ] ]
  set scent-ahead forhere-scent-at-angle   0
  set scent-right forhere-scent-at-angle  45
  set scent-left  forhere-scent-at-angle -45
  if (scent-right < scent-ahead) or (scent-left < scent-ahead)
  [ ifelse scent-right < scent-left
    [ rt 45 ]
    [ lt 45 ] ]
  set scent-ahead forhere-scent-at-angle   0
  set scent-right forhere-scent-at-angle  25
  set scent-left  forhere-scent-at-angle -25
  if (scent-right < scent-ahead) or (scent-left < scent-ahead)
  [ ifelse scent-right < scent-left
    [ rt 25 ]
    [ lt 25 ] ]
end
;; Report Functions - Used by the "Uphill-" functions to collect the values o
;; of the desired scent or pheromone
to-report forhere-scent-at-angle [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]
  report [forhere] of p
end
to-report fsource-scent-at-angle [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]
  report [fsource-scent] of p
end
to-report nest-scent-at-angle [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]
  report [nest-scent] of p
end
to-report ppheromone-scent-at-angle [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]
  report [ppheromone] of p
end
to-report fpheromone-scent-at-angle [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]
  report [fpheromone] of p
end
to-report forsource-scent-at-angle [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]
  report [forsource-scent] of p
end
to-report home-scent-at-angle [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]
  report [home-scent] of p
end
to-report middenpile-scent-at-angle [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]
  report [middenpile-scent] of p
end

;; Linking Functions - These are called by UpdateLink to make the connections between ants
;; on neighboring patches, what kind of link is create depends on the status of the
;; ant being linked to i.e. If a forager is currently carrying food.
to middenlink                                                 
  if count middenworkers-on neighbors != 0 and not nest?    
  [ ifelse any? middenworkers with [carryingmidden?] and distance one-of middenworkers with [carryingmidden?] < 1 
    [let mtemp one-of middenworkers-on neighbors
      create-mwmlink-to mtemp
      [ set linkvalue 400
        set hidden? true]]
    [let temp one-of middenworkers-on neighbors 
      create-mwlink-to temp
      [ set linkvalue 400
        set hidden? true]]]
end
to foragelink
  if count foragers-on neighbors != 0 
  [ ifelse any? foragers with [carryingfood?] and distance one-of foragers with [carryingfood?] < 1
    [let ftemp one-of foragers-on neighbors  
      create-fwflink-to ftemp
      [ set linkvalue 300
        set hidden? true]]
    [ let temp one-of foragers-on neighbors  
      create-flink-to temp
      [ set linkvalue 300
        set hidden? true]]]
end
to patrollink
  if count patrollers-on neighbors != 0 
  [ ifelse any? patrollers with [foodfound?] and distance one-of patrollers with [foodfound?] < 1
    [let ftemp one-of patrollers-on neighbors  
      create-prlink-to ftemp
      [ set linkvalue 300
        set hidden? true]]
    [let temp one-of patrollers-on neighbors  
      create-plink-to temp
      [ set linkvalue 300
        set hidden? true]]]
end
to foreignlink
  if count foreigners-on neighbors != 0 
  [ let temp one-of foreigners-on neighbors 
    create-slink-to temp
    [ set linkvalue 300
      set hidden? true]]
end
@#$#@#$#@
GRAPHICS-WINDOW
172
10
1109
507
-1
-1
6.143
1
10
1
1
1
0
0
0
1
0
150
0
75
1
1
1
ticks
30.0

SLIDER
-2
10
170
43
numberMidden
numberMidden
0
200
20
1
1
NIL
HORIZONTAL

SLIDER
-2
43
170
76
numberForage
numberForage
0
200
50
1
1
NIL
HORIZONTAL

SLIDER
-2
76
170
109
numberPatrol
numberPatrol
0
200
30
1
1
NIL
HORIZONTAL

BUTTON
12
555
158
647
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
14
690
159
793
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

PLOT
175
513
760
805
Colony Information Over Time
Time
Number of Ants or Food
0.0
15000.0
0.0
100.0
true
true
"" ""
PENS
"MiddenWorkers" 1.0 0 -16777216 true "" "plot count MiddenWorkers"
"Foragers" 1.0 0 -12087248 true "" "plot count Foragers"
"Patrollers" 1.0 0 -4079321 true "" "plot count Patrollers"
"FoodSupply" 1.0 0 -955883 true "" "plot foodstore"
"ColonySize" 1.0 0 -7500403 true "" "plot colonysize"

SLIDER
-2
141
170
174
DangerLevel
DangerLevel
0
5
3
1
1
NIL
HORIZONTAL

MONITOR
766
716
909
761
Number of Patrollers
Count Patrollers
17
1
11

MONITOR
766
514
909
559
Number of Foragers
count Foragers
17
1
11

MONITOR
766
615
908
660
Number of Midden Workers
count MiddenWorkers
17
1
11

INPUTBOX
83
233
170
293
FamineLevel
50
1
0
Number

MONITOR
919
558
1000
603
Food Supply
round foodstore
17
1
11

INPUTBOX
84
293
170
353
LifeSpan
100
1
0
Number

MONITOR
919
716
1080
761
Number of Untasked Ants
count nestworkers
17
1
11

INPUTBOX
-1
174
83
234
BirthRate
25
1
0
Number

MONITOR
1012
513
1076
558
Colony Size
colonysize
17
1
11

INPUTBOX
-1
233
83
293
DayLength
35
1
0
Number

MONITOR
968
514
1018
559
Time
round time
17
1
11

INPUTBOX
83
174
170
234
DeathRate
10
1
0
Number

INPUTBOX
0
293
84
353
Consumption
1
1
0
Number

MONITOR
919
760
1010
805
Unsorted Midden
unsortedmidden
17
1
11

MONITOR
995
557
1076
602
Ants in Nest
count turtles with [nest?]
17
1
11

MONITOR
919
514
969
559
Day
day
17
1
11

INPUTBOX
0
469
170
529
Night_Animation
off
1
0
String

MONITOR
766
558
909
603
% of Foragers Working
round (foragers_working * 100)
17
1
11

MONITOR
766
760
909
805
% of Patrollers Working
round (Patrollers_working * 100)
17
1
11

MONITOR
766
659
908
704
% MiddenWorkers Working
round (middenworkers_working * 100)
17
1
11

INPUTBOX
0
410
170
470
AntEater_Attacks
off
1
0
String

SLIDER
-2
109
170
142
numberForeign
numberForeign
0
50
17
1
1
NIL
HORIZONTAL

MONITOR
919
658
999
703
Foreign Food 
round foreignstore
17
1
11

MONITOR
919
614
1080
659
Number of Foreigners
numforeign
17
1
11

INPUTBOX
0
352
170
412
MinimumForeignerRange
50
1
0
Number

MONITOR
1009
760
1080
805
Middenpile
Piledmidden
17
1
11

MONITOR
998
658
1080
703
World Food
foodavail
17
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

ant
true
0
Polygon -7500403 true true 136 61 129 46 144 30 119 45 124 60 114 82 97 37 132 10 93 36 111 84 127 105 172 105 189 84 208 35 171 11 202 35 204 37 186 82 177 60 180 44 159 32 170 44 165 60
Polygon -7500403 true true 150 95 135 103 139 117 125 149 137 180 135 196 150 204 166 195 161 180 174 150 158 116 164 102
Polygon -7500403 true true 149 186 128 197 114 232 134 270 149 282 166 270 185 232 171 195 149 186
Polygon -7500403 true true 225 66 230 107 159 122 161 127 234 111 236 106
Polygon -7500403 true true 78 58 99 116 139 123 137 128 95 119
Polygon -7500403 true true 48 103 90 147 129 147 130 151 86 151
Polygon -7500403 true true 65 224 92 171 134 160 135 164 95 175
Polygon -7500403 true true 235 222 210 170 163 162 161 166 208 174
Polygon -7500403 true true 249 107 211 147 168 147 168 150 213 150

ant 2
true
0
Polygon -7500403 true true 150 19 120 30 120 45 130 66 144 81 127 96 129 113 144 134 136 185 121 195 114 217 120 255 135 270 165 270 180 255 188 218 181 195 165 184 157 134 170 115 173 95 156 81 171 66 181 42 180 30
Polygon -7500403 true true 150 167 159 185 190 182 225 212 255 257 240 212 200 170 154 172
Polygon -7500403 true true 161 167 201 150 237 149 281 182 245 140 202 137 158 154
Polygon -7500403 true true 155 135 185 120 230 105 275 75 233 115 201 124 155 150
Line -7500403 true 120 36 75 45
Line -7500403 true 75 45 90 15
Line -7500403 true 180 35 225 45
Line -7500403 true 225 45 210 15
Polygon -7500403 true true 145 135 115 120 70 105 25 75 67 115 99 124 145 150
Polygon -7500403 true true 139 167 99 150 63 149 19 182 55 140 98 137 142 154
Polygon -7500403 true true 150 167 141 185 110 182 75 212 45 257 60 212 100 170 146 172

anteater
true
0
Polygon -7500403 true true 175 54 166 1 158 46 156 60 151 76 136 91 106 91 91 91 91 100 123 122 128 136 129 148 130 155 126 164 124 173 92 187 91 196 115 198 130 199 152 201 153 240 160 272 179 293 181 241 182 201 185 131 178 84
Polygon -16777216 true false 150 45 195 105
Polygon -16777216 true false 150 75 165 105 165 135 150 105 135 90 150 75 135 90 150 75
Polygon -1 true false 150 105 135 105 105 90 135 90 150 105
Circle -16777216 true false 167 58 6

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
