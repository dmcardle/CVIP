function image = crop(image, amt)
    % Remember that amt=0 should have no change on the image.
    image = image(amt+1:end-amt, amt+1:end-amt);
end
