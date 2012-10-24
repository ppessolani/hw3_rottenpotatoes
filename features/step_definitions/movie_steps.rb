# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    @pelicula = Movie.where("title = ? AND rating = ? AND release_date = ?", movie["title"],movie["rating"],movie["release_date"])
    if(@pelicula==nil) 
     pelicula = Movie.new(:title => movie["title"], :rating => movie["rating"], :release_date => movie["release_date"])
     pelicula.save();
    end
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |t1, t2|
  assert page.body.index(t1) < page.body.index(t2) , "Not right order"
end

Then /I should see (none|all) of the movies/ do |accion|
  db_cant = 0
  db_cant = Movie.all.size if accion == "all"
  page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr) = #{db_cant} ]")
end

Then /I should (not )?see movies rated: (.*)/ do |negacion, rating_list|
  ratings = rating_list.split(",")
  ratings = Movie.all_ratings - ratings if negacion
  db_cant = filtered_movies = Movie.find(:all, :conditions => {:rating => ratings}).size
   page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr) = #{db_cant} ]")
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(",").each do | rating |
    rating = "ratings_" + rating
    if uncheck
      uncheck(rating)
    else
      check(rating)
    end
  end
end

When /I (un)?check all the ratings/ do |uncheck|
  Movie.all_ratings.each do | rating |
    rating = "ratings_" + rating
    if uncheck
      uncheck(rating)
    else
      check(rating)
    end
  end
end
