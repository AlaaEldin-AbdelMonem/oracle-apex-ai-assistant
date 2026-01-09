--------------------------------------------------------
--  Ref Constraints for Table DEPLOYMENT_VERSIONS
--------------------------------------------------------

  ALTER TABLE "AI8P"."DEPLOYMENT_VERSIONS" ADD CONSTRAINT "FK_DEPLOY_VER_SHADOW_PARENT" FOREIGN KEY ("SHADOW_PARENT_DEPLOYMENT_ID")
	  REFERENCES "AI8P"."DEPLOYMENT_VERSIONS" ("DEPLOYMENT_ID") ENABLE;
