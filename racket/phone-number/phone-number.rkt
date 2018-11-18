#lang racket

(provide numbers area-code pprint)

(define WRONG_NUMBER "0000000000")

(define (numbers number)
  (let* ([normalized (string-replace number #rx"[^0-9]" "")]
         [captures (regexp-match #rx"^1(.+)" normalized)])
    (cond
      [(and (= (string-length normalized) 10)) normalized]
      [(and (= (string-length normalized) 11)
            (> (length (or captures (list))) 1)) (second captures)]
      [WRONG_NUMBER])))

(define (parse-number number)
  (regexp-match  #rx"^(...)(...)(....)" (numbers number)))

(define (area-code number) (second (parse-number number)))

(define (pprint number)
  (let ([parsed (parse-number number)])
    (format "(~a) ~a-~a" (second parsed) (third parsed) (fourth parsed))))
