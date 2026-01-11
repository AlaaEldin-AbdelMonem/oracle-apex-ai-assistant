--------------------------------------------------------
--  Ref Constraints for Table DEPLOYMENT_VERSIONS
--------------------------------------------------------

  ALTER TABLE "DEPLOYMENT_VERSIONS" ADD CONSTRAINT "FK_DEPLOY_VER_SHADOW_PARENT" FOREIGN KEY ("SHADOW_PARENT_DEPLOYMENT_ID")
	  REFERENCES "DEPLOYMENT_VERSIONS" ("DEPLOYMENT_ID") ENABLE;
