# 0.2.0 / 2015-02-22

Require a dry-validation schema for each form. The schema should completely represent the form's expected data structure.

Update the API to better support the two main use cases for a form. First, to prepare a form with sane, initial input from your database and send it to a view for rendering:

```ruby
my_form = MyForm.new(my_schema)
my_form.build(input) # returns a `Formalist::Form::Result`
```

Then, to receive the data from the posted form, coerce it and validate it (and potentially re-display the form with errors):

```ruby
my_form = MyForm.new(my_schema)
my_form.receive(input).validate # returns a `Formalist::Form::ValidatedResult`
```

The main differences are as such:

* `#build` expects already-clean (e.g. properly structured and typed) data
* `#receive` expects the kind of data that your form will submit, and will then coerce it according to the validation schema, and then send the sanitised output to `#build`
* Calling `#validate` on a result object will validate the input data and include any error messages in its AST

# 0.1.0 / 2015-01-18

Initial release.
