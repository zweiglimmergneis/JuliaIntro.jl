# Kurze Einführung in Julia

## Keep calm and ask ...

```julia (editor=true, logging=false, output=true)
DOM.img(src=Asset(data"julia-logo.svg"))
```
---

## Merkmale

  * "Walks like Python, runs like C"
  * dynamisch typisiert
  * Typ-System mit parametrisierbaren Typen (Polymorphismus). Hierarchische Beziehungen zwischen den Typen sind explizit.
  * funktionsorientiert, Funktionen sind First-Class-Objekte
  * Method dispatch, multiple dispatch
  * Just ahead-of-time compilation; interaktiv nutzbar
  * Garbage collection

---

## Typen

|          |                                    |
|:-------- |:---------------------------------- |
| Char     | `c1 = 'q'`                         |
| Int      | `x = 3; x::Int = 3; x = Int(3)`    |
| Float64  | `p = 0.1`                          |
| Complex  | `z2 = 3 + 2im; z1 = Complex(3, 2)` |
| UInt8    | `b2 = 0b1100`                      |
| UInt16   | `b8 = 0o0014`                      |
| UInt16   | `b16 = 0x000c`                     |
| Symbol   | `spin = :up`                       |
| DataType | `T = Int`                          |
| Function | `f(x) = 2x`                        |
| Expr     | `ex = :(a + 2 * b)`                |

---

## Collections

|            |                                           |                                   |
|:---------- |:----------------------------------------- | ---------------------------------:|
| Tuple      | `t1 = (7, 22, 11, 34); t2 = (3,)`         |                                   |
| NamedTuple | `nt = (; a=10, b="shallow")`              |                                   |
| Array      | `v = [2, 4, 6, 8]`                        | auch mehrdimensional, Start bei 1 |
| Matrix     | `A = [3 1 3; 8 7 2]`                      |                                   |
| String     | `msg = "Gehe nicht über 'Los'"`           |                                   |
|            | `s = "\u2200 x \u2203 y"`                 |                           ∀ x ∃ y |
| Set        | `s = Set((1, 2, 3, 4, 5, 6))`             |                                   |
| Pair       | `p1 = 2 => "orange"; p2 = Pair(3, "rot")` |                                   |
| Dict       | `d = Dict(1 => "gelb", p1, p2)`           |                    vgl. PHP-Array |
| Struct     | eigene Typen (siehe unten)                |                                   |

---

## Typ NamedTuple

Variablen dieses Typs werden bei Bedarf dekonstruiert. Das kann praktisch sein für die Übergabe und Rückgabe von Funktionsparametern.

```julia (editor=true, logging=false, output=true)
function print_args(; canvas="paper", width=100, height=30, color="white")
   return """
      canvas: $(canvas) - 
      width: $(width) - 
      height: $(height) - 
      color: $(color)
   """   
end

# NamedTuple without `canvas`
arg_list = (width = 10, height = 20, color = "yellow") 

print_args(;arg_list...)
```
## Typisierung

Typ wird erschlossen

```julia (editor=true, logging=false, output=true)
n = 7
typeof(n)
```
```julia (editor=true, logging=false, output=true)
w = 3.85
typeof(w)
```
Typangabe in einer Deklaration

```julia (editor=true, logging=false, output=true)
struct TypeWithNumbers
    n::Int
    w::Float64
    z::Complex
end

twn_obj = TypeWithNumbers(3.4, 0.8, 5)
```
Explizite Typangabe in der Zuweisung

```julia (editor=true, logging=false, output=true)
n = Int(4)
```
```julia (editor=true, logging=false, output=true)
w = Float64(3.85)
```
```julia (editor=true, logging=false, output=true)
z = Complex(2, 1.8)
```
## Dispatch

```julia (editor=true, logging=false, output=true)
rand(7)
```
```julia (editor=true, logging=false, output=true)
rand(["oh", "du", "lieber", "Augustin"], 7) # with count; with range
```
```julia (editor=true, logging=false, output=true)
rand(100:4:200, 7)
```
```julia (editor=true, logging=false, output=true)
rand # methods
```
## Eigene Typen

```julia (editor=true, logging=false, output=true)
struct SFarmer
    name::String
end
struct SKnight
    name::String
end
struct SPriest
    name::String
end
```
```julia (editor=true, logging=false, output=true)
duty(p::SFarmer) = "$(p.name) arbeitet"
duty(p::SKnight) = "$(p.name) lernt [...]  mit Schild und Speer geschickt zu reiten, das Pferd zu beiden Seiten gebührend anzuspornen, es kühn im Galopp zu führen, zu wenden und mit verhängtem Zügel laufen zu lassen, es durch Schenkeldruck zu lenken ganz nach ritterlicher Art (Gottfried von Straßburg)"
duty(p::SPriest) = "$(p.name) betet"
```
```julia (editor=true, logging=false, output=true)
kuno = SKnight("Kuno")
walter = SFarmer("Walter")
gero = SPriest("Gero")
```
```julia (editor=true, logging=false, output=true)
duty(gero) * " und " * duty(kuno)
```
```julia (editor=true, logging=false, output=true)
duty(f::SFarmer, k::SKnight) = "$(f.name) versorgt $(k.name)"
duty(k::SKnight, f::SFarmer) = "$(k.name) beschützt $(f.name)"
```
```julia (editor=true, logging=false, output=true)
duty(walter, kuno) * " und " * duty(kuno, walter)
```
### Vererbung

```julia (editor=true, logging=false, output=true)
abstract type AbstractPerson end # convention 'Abstract ...'
struct Farmer<:AbstractPerson 
    name::String 
end
struct Knight<:AbstractPerson
    name::String
end
struct Priest<:AbstractPerson
    name::String
end
```
```julia (editor=true, logging=false, output=true)
duty(p::AbstractPerson) = "$(p.name) betet"
duty(k::Knight) = "$(k.name) lernt, mit Schild \u26e8 und Schwert zu reiten"
```
```julia (editor=true, logging=false, output=true)
walter = Farmer("Walter")
kuno = Knight("Kuno")
duty(walter) * " und " * duty(kuno)
```
```julia (editor=true, logging=false, output=true)
kuno = Knight("Kuno")
duty(kuno)
```
## Multiple Dispatch

```julia (editor=true, logging=false, output=true)
duty(k::Knight, p::AbstractPerson) = "$(k.name) schützt $(p.name)"
gero = Priest("Gero von Sell")
duty(kuno, gero)
```
```julia (editor=true, logging=false, output=true)
duty(kuno, walter)
```
```julia (editor=true, logging=false, output=true)
duty(p::AbstractPerson, q::AbstractPerson) = "$(p.name) achtet $(q.name)"
duty(walter, kuno)
```
## Type Hierarchy

```julia (editor=true, logging=false, output=true)
DOM.img(src=Asset(data"Type-hierarchy-for-julia-numbers.png"), width=800)
```
```julia (editor=true, logging=false, output=true)
factorial(big(84)) # 17, 17.0, 84
```
```julia (editor=true, logging=false, output=true)
m = 4
p = 1
p && m
```
### Syntax für Arrays, das Spinde-Rätsel

Die Badesaison klinkt aus. Bademeister Herbert langweilt sich. Er öffnet alle (numerierten) Spinde. Dann geht er mehrmals durch die Reihe und schließt jeden offenen Spind und öffnet jeden geschlossenen Spind. Dabei lässt er zunächst eine Tür aus, dann zwei, dann drei, und so weiter...

Welche Nummern sind am Ende offen?

```julia (editor=true, logging=false, output=true)
function locker_quiz(n)
    lockers = fill(true, n)
    for k in 2:n
        lockers_swap = @view lockers[k:k:end] # avoid allocation
        lockers_swap .= .!lockers_swap # use broadcasting
    end         
    return findall(lockers)
end
```
```julia (editor=true, logging=false, output=true)
join(locker_quiz(1000), ", ", " und ")
```
## Nützliche Pakete

  * Revise: Code in der Entwicklung wird aktualisiert
  * Markdown (Standardbibliothek): Teil der Standardbibliothek, unterstützt $\LaTeX$
  * DataFrames: split - apply - Wer sich mit R auskennt, wird sich (fast) wie zuhause fühlen
  * MySQL, SQLite, DuckDB, FunSQL: Datenbank-Anbindung
  * Statistics (Standardbibliothek)
  * JuliaML, Flux: Machine Learning
  * Transformer: LLM-Anbindung
  * Plots, Makie, Cairo, Bonito: Graphik
  * URIs, HTTP, Oxygen, Genie: Web
  * Textanalysis: NLP
  * Distributed Computing (Standardbibliothek)
  * Cuda

## Tooling

  * Julia REPL
  * VSCode/VSCodium
  * JetBrains-Plugin (kostenpflichtig)
  * Zed, Emacs
  * IJulia (Jupyter), Pluto, BonitoBook
  * Quarto

---

