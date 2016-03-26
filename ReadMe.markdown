# Installing

You should be able to install everything by doing the following:

    gem install bundler
    bundler install
    
Then you should have everything you need, because the `Gemfile` tells `bundler` what to get.

# Testing

To test the site, you can run the following command:

    middleman
    
That it. Then you can visit the [localhost:4567](localhost:4567) to see the latest content.

# Publishing

Create a `.s3_sync` file in the root of the project. This should have the following form:

    ---
    aws_access_key_id: <access key>
    aws_secret_access_key: <secret key>
    bucket: soundofftech-org
    
You *should* have downloaded this information when you signed in, but you can get this information from the [AWS Console](https://032141408253.signin.aws.amazon.com/console). I think the easiest way is to change your password.

To publish the site, execute the following commands:

    middleman build
    middleman s3_sync
    
This builds the site and then syncs it with S3. It will automatically invalidate any necessary files in Cloudfront.

# Blogging

We have several customisations for blogging.

## Author

When publishing a blog post, you can credit the post to an author with the YAML front matter field `author:`. This field will link to a file in the folder `~/data/authors` with the same name as the author. For example:

    author: Jeff Watkins
    
This post will reference the author file `Jeff Watkins.yaml`. The author file provides the profile information that gets included at the bottom of a post. The fields available in the author file include:

* `profile` – A short blurb about the author.
* `avatar` – The path to the 200x200 px image of the author's photo. Should be in the `images` folder. For example `/images/jeff.png`
* `name` – The full name of the author.
* `twitter_username` – If provided, this will be used to include a link to the author's twitter account.
* `website_url` – if provided, this will be used to include a link to the author's personal website.
* `website_name` – Used in conjunction with the `website_url`.

## Campaigns

We can also link a blog post to a campaign. Each campaign has its own page in the `campaigns` folder, but appears in the root of the URL space (just life). If you want to attribute a blog post to a campaign, add the following to the YAML front matter:

    campaign: alterconf
    
Then when pages are generated, if the campaign is active, it will get a prominent DONATE link.
