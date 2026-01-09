--------------------------------------------------------
--  Ref Constraints for Table DEPLOYMENT_EXPERIMENTS
--------------------------------------------------------

  ALTER TABLE "AI8P"."DEPLOYMENT_EXPERIMENTS" ADD CONSTRAINT "FK_EXP_WINNER_DEPLOY" FOREIGN KEY ("WINNER_DEPLOYMENT_ID")
	  REFERENCES "AI8P"."DEPLOYMENT_VERSIONS" ("DEPLOYMENT_ID") ENABLE;
