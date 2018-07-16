# chemCal 0.2.1 (2018-07-16)

- 'lod' and 'loq': In the lists that are returned, return the list component 'y' without names, because we always have a single element in 'y' and the name '1' is meaningless 

- Use testthat for tests to simplify further development

- Convert vignette to html

- Add another example dataset, from an online course at the University of Toronto

# chemCal 0.1-33 (2014-04-24)

- Bugfix in lod() and loq(): In the case of small absolute x values (e.g. on
	the order of 1e-4 and smaller), the lod or loq calculated using the default
	method could produce inaccurate results as the default tolerance that was
	used in the internal call to optimize is inappropriate in such cases. Now a
	reasonable default is used which can be overriden by the user. Thanks to
	Jérôme Ambroise for reporting the bug.

For a detailed list of changes to the chemCal source please consult the commit history on https://cgit.jrwb.de/chemCal
