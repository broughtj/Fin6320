# Finance 6320: Computational Finance

### January 17, 2017

<br>

Today's Agenda:

1. Review of installations, setup, etc. Also questions?
2. Computer Representation of Numbers
3. Algorithms

---

## Installation, Setup, Etc

<br>
<br>

Questions?

___

## Computer Representation of Numbers

<br>

It is crucial to understand that computers __DO NOT__ represent numbers the same way that we do as humans. 

<br>

The Word _digital_ in digital computer means that computers use binary digits, that is 0's and 1's to represent numbers. This is also known as base 2 representation.

___

## Two Guiding Principles

Throughout the course we will repeat two guiding principles:

<br>

1. _Computer numbers are not the same as real numbers, and the arithmetic operations on computer numbers are not exactly the same as those of ordinary arithmetic._

<br>

2. _The form of a mathematical expression and the way the expression should be evaluated in actual practice may be quite different._

<br>
<br>

Reference: [Gentle](https://goo.gl/knKqZ7)


---

# Computer Representation of Numbers

## Numbers in Base 10

In the familiar decimal (base 10) system, numerical values are represented in units or powers of 10. 

<br>

Now we can use the ___Basic Representation Theorem___, which says we can represent a number, $k$, as

$$
k = \sum\limits_{j=0}^{m} a_{j} (10)^{j}
$$

for some unique integer $m$ and some set of integer coefficients ${a_{0}, \ldots, a_{m}}$.

---

## An Example

As an example, consider the following:

$$
193 = 1 \ast (10)^{2} + 9 \ast (10)^{1} + 3 \ast (10)^0
$$


