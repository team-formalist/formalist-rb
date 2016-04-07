# 0.2.3 / 2016-04-07

Default check_box element values to false.

# 0.2.2 / 2016-02-23

Remove local type coercion using dry-data. We rely on a `Dry::Validation::Schema` to do this now. The form definition API has not yet changed, though. We still require field types to be specified, but there is no longer any restriction over what is entered. We'll remove this in a future release, once we can infer types from the schema.

# 0.2.1 / 2016-02-23

Fix issue where form could not be built with input data with native data types (it presuming input would be HTML form-style input everywhere).

Add default (empty) input data argument for `Form#build`. This allows you simply to call `MyForm.build` for creating a "new" form (i.e. one without any existing input data).

# 0.2.0 / 2016-02-22

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

# 0.1.0 / 2016-01-18

Initial release.
