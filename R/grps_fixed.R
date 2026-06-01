    if (k>1){
      se <- tapply(dataf$x, dataf$f, sd, na.rm = TRUE)
      ic_inf=vector( length=length(se))
      ic_sup=vector( length=length(se))
      for(i in 1:length(se)) {
        group_name <- names(se)[i]
        if(haymiss) gsize <- t[group_name, "n_valido"] else gsize <- t[group_name, "n"]
        interv <- icm(n=as.numeric(gsize), m=as.numeric(t[group_name, "media"]), s=as.numeric(se[i]), decs=decs, conf=conf, eco=FALSE)
        ic_inf[i] = round(interv[[1]], decs)
        ic_sup[i] = round(interv[[2]], decs)
      }
