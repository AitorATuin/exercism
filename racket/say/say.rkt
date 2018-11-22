#lang racket/base

;; Converts integers to English-language descriptions

;; --- NOTE -------------------------------------------------------------------
;; The test cases in "say-test.rkt" assume:
;; - Calling a function with an out-of-range argument triggers a contract error
;; - That `step3` returns a list of (number, symbol) pairs
;;
;; We have provided sample contracts so the tests compile, but you
;;  will want to edit & strengthen these.
;;
;; (For example, things like 0.333 and 7/8 pass the `number?` contract
;;  but these functions expect integers and natural numbers)
;; ----------------------------------------------------------------------------

(require racket/contract)

(require racket/match)

(provide (contract-out
  [step1 (-> number? string?)]
  ;; Convert a positive, 2-digit number to an English string

  [step2 (-> number? (listof number?))]
  ;; Divide a large positive number into a list of 3-digit (or smaller) chunks

  [step3 (-> number? (listof (cons/c number? symbol?)))]
  ;; Break a number into chunks and insert scales between the chunks

  [step4 (-> number? string?)]
  ;; Convert a number to an English-language string
))

;; =============================================================================

(define number-as-string (hash
                          0 "zero"
                          1 "one"
                          2 "two"
                          3 "three"
                          4 "four"
                          5 "five"
                          6 "six"
                          7 "seven"
                          8 "eight"
                          9 "nine"
                          10 "ten"
                          11 "eleven"
                          12 "twelve"
                          13 "thirteen"
                          15 "fifteen"
                          18 "eighteen"
                          20 "twenty"
                          30 "thirty"
                          40 "forty"
                          50 "fifty"
                          60 "sixty"
                          70 "seventy"
                          80 "eighty"
                          90 "ninety"))

(define scales (list 'END 'thousand 'million 'billion 'trillion))

(define (scale->string scale)
  (if (equal? scale 'END) "" (string-append " " (symbol->string scale))))

(define (step1 n)
  (let ([s (hash-ref number-as-string n 'none)])
    (cond
      [(not (equal? s 'none)) s]
      [(< n 0) (error "Number must be positive")]
      [(> n 99) (error "Number must be < 100")]
      [(< n 20) (string-append (step1 (remainder n 10)) "teen")]
      [else (string-append
             (step1 (* (quotient n 10) 10))
             "-"
             (step1 (remainder n 10)))])))

(define (thousand-chunk n scale #:first [first #f])
  (cond
    [(zero? n) (if first "zero" "")]
    [(< n 100) (string-append (step1 n) (scale->string scale))]
    [else (string-append (step1 (quotient n 100))
                         " hundred "
                         (thousand-chunk (remainder n 100) scale)
                         (scale->string scale))]))

(define (step2 n [res null])
  (cond
    [(< n 1000) (cons n res)]
    [(step2 (quotient n 1000) (cons (remainder n 1000) res))]))

(define (step3 n)
   (reverse (for/list ([i (reverse (step2 n))]
                       [s scales]
                       #:when (>= i 0))
     (cons i s))))

(define (step4 n)
  (let ([chunks (step3 n)])
    (foldl (λ (p str) (string-append str " " (thousand-chunk (car p) (cdr p))))
           (thousand-chunk (caar chunks) (cdar chunks) #:first #t)
           (cdr chunks))))
